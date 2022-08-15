import 'package:flutter/material.dart';

class SelectModal {
  static open(
    BuildContext context,
    Map<String, String> languages,
    Function onSelect,
  ) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: ((context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: languages.entries
                  .map(
                    (e) => TextButton(
                      onPressed: () {
                        onSelect(e.key);
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            e.value,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      }),
    );
  }

  static openLanguage() {}

  static openCurrency() {}
}
