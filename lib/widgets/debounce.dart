import 'dart:async';

class Debounce {
  int delay;
  Timer? _timer;

  Debounce(
    this.delay,
  );

  call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: delay), callback);
  }

  dispose() {
    _timer?.cancel();
  }
}


// Timer? _debounce;

// _onSearchChanged(String query) {
//   if (_debounce?.isActive ?? false) _debounce?.cancel();
//   _debounce = Timer(const Duration(milliseconds: 500), () {
//     print('coba $query');
//     BlocProvider.of<TransactionBloc>(context)
//         .add(TransactionCustomerFetchEvent(phone: query));
//   });
// }


//cara pakai 

// ........
//  onChanged: (val){
//         _onSearchChanged(val);
//       },
// .......