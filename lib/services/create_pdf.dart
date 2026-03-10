import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Document createPdf() {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(child: pw.Text("Hello, world!"));
      },
    ),
  );

  return pdf;
}
