import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.15,
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Center(child: Text('Суретті өзгерту')),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const Text('Есіміңізді өзгерту'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24)),
                  hintText: 'Атыныз',
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Text('Тегіңізді өзгерту'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24)),
                  hintText: 'Тегыныз',
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Text('Тілді таңдау'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              DropdownMenu<String>(
                width: MediaQuery.of(context).size.width * 0.8,
                dropdownMenuEntries: const [
                  DropdownMenuEntry<String>(
                    label: 'Казакша',
                    value: 'Казакща',
                  ),
                  DropdownMenuEntry<String>(
                    label: 'Орысша',
                    value: 'Орысша',
                  ),
                ],
                hintText: 'Тілді таңдау',
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Text('Құпиясөзді өзгерту'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.375,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        constraints: BoxConstraints.tight(
                          const Size.fromHeight(40),
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                bottomLeft: Radius.circular(24))),
                        hintText: 'Ескі',
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.375,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        constraints: BoxConstraints.tight(
                          const Size.fromHeight(40),
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(24),
                                bottomRight: Radius.circular(24))),
                        hintText: 'Жаңа',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(24),color: Color(0xFF00343F)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Text(
                    'Өзгерістерді Сақтау',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
