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
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) => model.init(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Expenses'),
          ),
          body: FutureBuilder(
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
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Card(
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              builder: (context) => HomeView(
                                                    expanseId: item['id'],
                                                  ))),
                                      child: const Icon(Icons.edit)),
                                  GestureDetector(
                                      onTap: () =>
                                          viewModel.deleteExpense(item['id']),
                                      child: const Icon(Icons.delete)),
                                  TextButton(
                                    onPressed: () {
                                      viewModel.makePayment(item['amount'],
                                          item['currency'], item['receipt']);
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
