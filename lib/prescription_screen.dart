import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrescriptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  void _printDocument() {
    Printing.layoutPdf(
      onLayout: (pageFormat) {
        final doc = pw.Document();
        doc.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Container(
              child: pw.Column(
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                            "Click Health",
                            style: pw.TextStyle(
                              fontSize: 28,
                            ),
                            textAlign: pw.TextAlign.left
                        ),
                        pw.Container(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text("Fatema Begum"),
                              pw.Text("Professor Dr. P.K. Saha, Advanced Laparoscopic"),
                              pw.Text("Centre & Hernia ClinicDR. MD. REHAN HABIB"),
                              pw.Text("Obstetrician Gynecologist, Psychiatrist, Surgeon"),
                              pw.Text(" BMDC NO : 192345"),
                            ],
                          ),
                        )
                      ]
                  ),
                  pw.Divider(),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Patient Details"),
                              pw.Text("Name : Masudur rahman"),
                              pw.Text("Age : 44 years 10 months"),
                              pw.Text("Gender : Male")
                            ]
                        ),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text("Case Id : 202005270001"),
                              pw.Text("Appointment date : 2020-05-27"),
                              pw.Text("Age : 44 years 10 months"),
                              pw.Text("Appointment time : 08:00 AM")
                            ]
                        ),
                      ]
                  ),
                  pw.Divider(),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 5,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Chief Complaints : back pain"),
                                pw.Text("Diagnosis : Lorem Ipsum is simply dummy text of the printing and typesetting industry"),
                                pw.Text("Test Ordered : Broken bones"),
                                pw.Text("Referral Required - Anesthesiology"),
                              ]
                          ),
                        ),
                        pw.Container(height: 200, child: pw.VerticalDivider()),
                        pw.Expanded(
                          flex: 5,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Medication :"),
                                pw.Text("1. Injection Napa Extra 500mg 0 + 0 + 2 - 34 days (Apply locally)"),
                                pw.Text("2. Suppository Bisoprolol 2 + 2 + 2 - 34 days (Before meal)"),
                                pw.Text("3. Injection Napa 0 + 1/2 + 0 - 20 days (Per Vaginal)"),
                              ]
                          ),
                        ),
                      ]
                  ),
                  pw.Divider(),
                  pw.Container(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(height: 24),
                            pw.Text("CONDITIONS APPLY :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 16),
                            pw.Text("1. We have issued a verified e-prescription which should be used upon complete user discretion and responsibility."),
                            pw.Text("2. ClickHealth Services will not carry any liability for any misuse or abuse of the prescription."),
                            pw.Text("3. The e-prescription is not a substitute for professional medical advice, diagnosis or treatment."),
                            pw.Text("4. For verification of prescription of doctor's referral, you can review issuance with ClickHealth Service and for verification of doctor use the BMDC No at http://bmdc.org.bd/doctors.info/.")
                          ]
                      )
                  )
                ],
              ),
            ),
          ),
        );

        return doc.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        leading: Container(),
        title: Text("Prescription"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Stack(
            children: <Widget>[
//                Opacity(
//                  opacity: 0.1,
//                  child: SvgPicture.asset(
//                    ImageUtil.of(context).cattleSvgIcon,
//                    fit: BoxFit.fill,
//                    height: double.infinity,
//                    width: double.infinity,
//                  ),
//                ),
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: IconButton(
                    icon: Icon(Icons.print),
                    onPressed: _printDocument,
                  )
              )
            ]
        ),
      ),
    );
  }
}
