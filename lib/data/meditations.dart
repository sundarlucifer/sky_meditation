import '../models/models.dart';

class Meditations {
  final thuriyam = Meditation('Thuriyatheetham', [
    Section('Irai vanakkam', 'irai_vanakkam_ellam_valla_deivamathu.mp3', null),
    Section('Guru vanakkam', 'guru_vanakkam_puruvathhidai.mp3', null),
    Section('Naadi Sudhhi', 'naadi_sudhhi.mp3', Duration(minutes: 2)),
    Section('Thanduvada Sudhhi', 'thanduvada_sudhhi.mp3', Duration(minutes: 5)),
    Section('Vanakkam + Thooymai', 'thavam_thuvakkam.mp3', null),
    Section('Agna Thavam', 'agna.mp3', Duration(minutes: 5)),
    Section('Thuriyam', 'thuriyam.mp3', Duration(minutes: 10)),
    // Add 'Spread thava aatral throughout body'
    Section('Sangalpam', 'sangalpam.mp3', null),
    Section('Vaazhthukkal', 'vaazhthukkal.mp3', null),
    Section('Irandozhukka panbaadu', 'irandozhukka_panbaadu.mp3', null),
    Section('Mazhai Vaazhthu', 'mazhai_vaazhthhu.mp3', null),
    Section('Uzhaganala Vaetpu', 'song_uzhagilulla_poruppudaiya.mp3', null),
    Section('Thavam Mudivu', 'thavam_mudivu.mp3', null),
  ]);
}