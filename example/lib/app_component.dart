import 'package:angular/angular.dart';

import 'qr_code_component.dart';

@Component(
  selector: 'my-app',
  template: '<qr-code size="600" value="{{qrValue}}"></qr-code>',
  directives: [
    QrCodeComponent,
  ],
)
class AppComponent {
  String qrValue = "https://imgflip.com/i/3nd3p1";
  var name = 'Angular';
}
