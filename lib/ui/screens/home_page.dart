import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_invoice/const/string_const.dart';
import 'package:simple_invoice/providers/theme_provider.dart';
import 'package:simple_invoice/providers/user_provider.dart';
import 'package:simple_invoice/routes/route_const.dart';

import '../../data/models/invoice_model.dart';
import '../../providers/invoice_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final invoicesList = ref.watch(invoiceListProvider);
    final user = ref.watch(userAuthProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text(StringConst.appName),
          actions: [
            TextButton(
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now())
                    .then((value) {
                  if (value != null) {
                    ref.read(invoiceListProvider.notifier).filterByDate(value);
                  }
                });
              },
              child: const Icon(Icons.calendar_month_outlined),
            ),
          ],
        ),
        drawer: Builder(builder: (context) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        radius: 40,
                        child: user.value!.logoUrl.isEmpty
                            ? const Icon(Icons.person)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  user.value!.logoUrl,
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(user.value!.name),
                    ],
                  ),
                ),
                ListTile(
                  trailing: const Icon(Icons.person_outline),
                  title: const Text('Update Profile'),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Navigator.pushNamed(context, RouteConst.updateProfile);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.info_outline_rounded),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RouteConst.about);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.login_outlined),
                  title: const Text('Sign Out'),
                  onTap: () async {
                    Scaffold.of(context).closeDrawer();
                    await ref.read(userAuthProvider.notifier).signOut();
                    if (mounted) {
                      Navigator.pushReplacementNamed(
                          context, RouteConst.signIn);
                    }
                  },
                ),
                ListTile(
                  // value: isDark,
                  title: const Text('Dark Theme'),
                  trailing: SizedBox(
                    width: 4.w,
                    child: Switch(
                      value: isDark,
                      splashRadius: 8,
                      thumbIcon: MaterialStatePropertyAll(
                          Icon(isDark ? Icons.dark_mode : Icons.light_mode)),
                      onChanged: (value) {
                        ref.read(themeProvider.notifier).toggleValue(value);
                        // Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref
                .read(invoiceProvider.notifier)
                .updateState(InvoiceModel.fromMap({"itemList": []}));
            Navigator.pushNamed(context, RouteConst.createInvoice);
          },
          child: const Icon(Icons.add),
        ),
        body: invoicesList.when(data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(invoiceListProvider.notifier).fetchList();
            },
            child: data.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 80.h,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Your Invoice List is empty!"),
                        ),
                      ),
                    ))
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return index == 0 ||
                              !dateCompare(data.elementAt(index).createdAt,
                                  data.elementAt(index - 1).createdAt)
                          ? Column(
                              children: [
                                Text(DateFormat("MMMM dd, yyy")
                                    .format(data.elementAt(index).createdAt)),
                                ListTile(
                                  title:
                                      Text(data.elementAt(index).customerName),
                                  subtitle: Text(
                                      data.elementAt(index).customerAddress),
                                  onTap: () {
                                    ref
                                        .read(invoiceProvider.notifier)
                                        .updateState(data.elementAt(index));
                                    Navigator.pushNamed(
                                        context, RouteConst.invoice);
                                  },
                                ),
                              ],
                            )
                          : ListTile(
                              title: Text(data.elementAt(index).customerName),
                              subtitle:
                                  Text(data.elementAt(index).customerAddress),
                              onTap: () {
                                ref
                                    .read(invoiceProvider.notifier)
                                    .updateState(data.elementAt(index));
                                Navigator.pushNamed(
                                    context, RouteConst.invoice);
                              },
                            );
                    }),
          );
        }, error: (error, stackTrace) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(invoiceListProvider.notifier).fetchList();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 80.h,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(error.toString().split(":")[1]),
                  ),
                ),
              ),
            ),
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}

bool dateCompare(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
