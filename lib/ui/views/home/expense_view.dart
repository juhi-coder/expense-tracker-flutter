import 'package:expanse_tracker/ui/views/home/home_view.dart';
import 'package:expanse_tracker/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({
    super.key,
  });

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) => model.init(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Expenses',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (query) {
                    viewModel.searchExpenses(query);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: viewModel.getExpenses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data avilable'));
                      } else if (snapshot.hasError) {
                        throw Exception('failed to fetch data');
                      } else {
                        return ListView.builder(
                            itemCount: viewModel.filterUsers.length,
                            itemBuilder: (context, index) {
                              final item = viewModel.filterUsers[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Card(
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item['name']),
                                        Text(item['category']),
                                        Text('${item['amount']}')
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeView(
                                                          expanseId: item['id'],
                                                        ))),
                                            child: const Icon(Icons.edit)),
                                        GestureDetector(
                                            onTap: () => viewModel
                                                .deleteExpense(item['id']),
                                            child: const Icon(Icons.delete)),
                                        TextButton(
                                          onPressed: () {
                                            final amount = int.tryParse(
                                                    item['amount']
                                                        .toString()) ??
                                                0;
                                            viewModel.makePayment(
                                              amount,
                                              item['currency'] ??
                                                  'Unknown currency',
                                              item['receipt'] ??
                                                  'No receipt available',
                                            );
                                          },
                                          child: const Text('Buy'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    }),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeView(
                    expanseId: null,
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
