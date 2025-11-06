import '../model/question_model.dart';

class BibleEventsQuestions {
  static final List<Question> questions = [
    Question(
      question:
      'Berapa lama hujan turun saat air bah zaman Nuh?',
      correctAnswer: '40 hari 40 malam',
      options: ['40 hari 40 malam', '7 hari 7 malam', '100 hari', '1 tahun'],
    ),
    Question(
      question: 'Apa yang terjadi dengan bahasa manusia setelah mereka membangun Menara Babel?',
      correctAnswer: 'Bahasa mereka dikacaukan',
      options: ['Bahasa mereka dikacaukan', 'Mereka lupa berbicara', 'Bahasa menjadi satu', 'Mereka tidak bisa menulis'],
    ),
    Question(
      question: 'Di gunung mana Abraham hampir mengorbankan anaknya sebelum Allah menyediakan domba sebagai pengganti?',
      correctAnswer: 'Gunung Moria',
      options: ['Gunung Moria', 'Gunung Sinai', 'Gunung Karmel', 'Gunung Zion'],
    ),
    Question(
      question: 'Apa yang dilakukan saudara-saudara Yusuf terhadap jubahnya setelah menjualnya?',
      correctAnswer: 'Mencelupkannya dengan darah kambing',
      options: ['Mencelupkannya dengan darah kambing', 'Membakarnya', 'Menyembunyikannya', 'Memberikannya kepada Yakub'],
    ),
    Question(
        question: 'Apa nama makanan yang Allah kirimkan dari surga untuk memberi makan bangsa Israel di padang gurun?',
        correctAnswer: 'Manna',
        options: ['Manna', 'Roti', 'Kurma', 'Ikan']
    ),
  ];
}