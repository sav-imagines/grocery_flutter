import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Document createPdf() {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Table(
          border: pw.TableBorder.all(color: PdfColor.fromInt(0x00ff00)),
          children: List.generate(
            12,
            (i) => pw.TableRow(
              children: List.generate(5, (j) => pw.Text("$i, $j")),
            ),
          ),
        );
      },
    ),
  );

  return pdf;
}
