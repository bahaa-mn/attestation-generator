import 'package:acfgen/utils/constants.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/formtateurs.dart';

class PdfGenerator {
  static reportView(context, Map data) async {
    final mainTitleStyle = TextStyle(
      fontSize: 19.0,
      fontWeight: FontWeight.bold,
    );
    final subtitleStyle = TextStyle(fontSize: 11.0);
    final infoStyle = TextStyle(fontSize: 14.0);

    final Document pdf = Document();

    final name = data[MapAttrs.name];
    final addresse = data[MapAttrs.addresse];
    final ville = data[MapAttrs.city];
    final birthCity = data[MapAttrs.birthCity];
    final birthday = Formats.date(data[MapAttrs.birthday]);
    final date = Formats.date(data[MapAttrs.date]);
    final heure = Formats.heure(data[MapAttrs.heure]);

    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(13.0),
        build: (Context context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "ATTESTATION DE DÉPLACEMENT DÉROGATOIRE",
                      textAlign: TextAlign.center,
                      style: mainTitleStyle,
                    ),
                  ),
                  Text(
                    "En application de l'article 51 du décret n° 2020-1262 du 16 octobre 2020 prescrivant les mesures générales nécessaires pour faire face à l'épidémie de covid-19 dans le cadre de l'état d'urgence sanitaire",
                    textAlign: TextAlign.center,
                    style: subtitleStyle,
                  ),
                  SizedBox(height: 23.0),
                  Text('Je soussigné(e),', style: infoStyle),
                  Text('Mme/M. : $name', style: infoStyle),
                  Text(
                    'Né(e) le : $birthday \t à : $birthCity',
                    style: infoStyle,
                  ),
                  Text('Demeurant : $addresse', style: infoStyle),
                  SizedBox(height: 23.0),
                  Text(
                    'certifie que mon déplacement est lié au motif suivant (cocher la case) autorisé en application des mesures générales nécessaires pour faire face à l\'épidémie de Covid19 dans le cadre de l\'état d\'urgence sanitaire¹ :',
                    style: infoStyle,
                  ),
                  SizedBox(height: 23.0),
                  ...MotifValue.list.map(
                    (e) {
                      final isSelected = data[MapAttrs.motif] == e;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text('[ ${isSelected ? 'X' : '  '} ]'),
                              ),
                              SizedBox(width: 17.0),
                              Flexible(
                                flex: 12,
                                child: Text('${e['long']}'),
                              ),
                            ],
                          ),
                          SizedBox(height: 13.0),
                        ],
                      );
                    },
                  ).toList(),
                  SizedBox(height: 23),
                  Text('Fait à : $ville', style: infoStyle),
                  SizedBox(height: 13.0),
                  Text(
                    'Le : $date à : $heure',
                    style: infoStyle,
                  ),
                  Text(
                    '(Date et heure de début de sortie à mentionner obligatoirement)',
                    style: subtitleStyle,
                  ),
                  SizedBox(height: 13.0),
                  Text('Signature : ', style: infoStyle),
                ],
              ),
              Text(
                '1 : Les personnes souhaitant bénéficier de l\'une de ces exceptions doivent se munir s\'il y a lieu, lors de leurs déplacements hors de leur domicile, d\'un document leur permettant de justifier que le déplacement considéré entre dans le champ de l\'une de ces exceptions',
                style: TextStyle(fontSize: 7.0),
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  static void saveFile(context, Map data) async {
    final pdf = await reportView(context, data);

    final fileName = Formats.fileName(data);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$fileName.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
  }
}
