import 'dart:html';

import 'package:angular/angular.dart';
import 'dart:math' as math;
import 'package:qr/qr.dart';


@Component(
  selector: 'qr-code',
  template: '''
    <div [style.width]="size + 'px'" [style.height]="size + 'px'">
      <canvas [height]="canvasSize()" [width]="canvasSize()" id='qrcontent' [style.width]="size + 'px'" [style.height]="size + 'px'"></canvas>
    </div>
  ''',
  directives: [
    coreDirectives,
  ],
)
class QrCodeComponent implements AfterViewInit {
  Element _element;

  QrCodeComponent(this._element);

  @Input()
  String size;

  String canvasSize() {
    return "${num.parse(size) * 10}";
  }

  String _value;

  @Input()
  void set value(String val) {
    _value = val;
    drawQrCode();
  }

  void drawQrCode() {
    print("QR VALUE: $_value");
    bool created = false;

    int typeNumber = 0;
    var errorCorrectLevel = QrErrorCorrectLevel.M;

    final List<bool> squares = List<bool>();

    while (!created) {
      ++typeNumber;
      if(typeNumber > 10 && errorCorrectLevel == QrErrorCorrectLevel.M) {
        typeNumber = 0;
        errorCorrectLevel = QrErrorCorrectLevel.L;
        continue;
      }

      final code = QrCode(typeNumber, errorCorrectLevel);
      code.addData(_value);

      try {
        code.make();
      } catch (e) {
        print("will retry...");
        continue;
      }
      created = true;
      for (int x = 0; x < code.moduleCount; x++) {
        for (int y = 0; y < code.moduleCount; y++) {
          squares.add(code.isDark(y, x));
        }
      }
    }

    CanvasElement canvas = _element.querySelector("canvas#qrcontent");

    final ctx = canvas.context2D;

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    final size = math.sqrt(squares.length).toInt();

    final minDimension = math.min(canvas.width, canvas.height);

    final scale = minDimension / size;

    ctx.save();
    ctx.scale(scale, scale);

    if (squares.length > 0) {
      assert(squares.length == size * size);
      for (int x = 0; x < size; x += 1) {
        for (int y = 0; y < size; y += 1) {
          if (squares[x * size + y]) {
            ctx.fillStyle = 'black';
          } else {
            ctx.fillStyle = 'white';
          }
          ctx.fillRect(x, y, 1, 1);
        }
      }
    }
    ctx.restore();
  }

  @override
  void ngAfterViewInit() {
    drawQrCode();
  }


}