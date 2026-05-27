class TriviaQuestion {
  final int id;
  final String category;
  final String question;
  final List<String> options;
  final int correct;
  final String funFact;

  const TriviaQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
    required this.correct,
    required this.funFact,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'options': options,
      'correct': correct,
      'funFact': funFact,
    };
  }

  factory TriviaQuestion.fromMap(Map<String, dynamic> map) {
    return TriviaQuestion(
      id: map['id'],
      category: map['category'],
      question: map['question'],
      options: List<String>.from(map['options']),
      correct: map['correct'],
      funFact: map['funFact'],
    );
  }
}

// ── CONSTANT TRIVIA POOL ───────────────────────
final List<TriviaQuestion> kTriviaPool = [
  TriviaQuestion(
    id: 0,
    category: 'naturaleza',
    question: '¿Cuántos años tarda en degradarse una botella de plástico?',
    options: ['10 años', '100 años', '450 años'],
    correct: 2,
    funFact: 'Una botella de plástico tarda unos 450 años en descomponerse. ¡Casi medio milenio!',
  ),
  TriviaQuestion(
    id: 1,
    category: 'naturaleza',
    question: '¿Qué porcentaje del agua del planeta es agua dulce accesible?',
    options: ['25%', 'Menos del 1%', '10%'],
    correct: 1,
    funFact: 'Solo el 0.5% del agua del planeta es dulce y accesible. ¡Cada gota cuenta!',
  ),
  TriviaQuestion(
    id: 2,
    category: 'curiosidades',
    question: '¿Cuántos árboles se necesitan para producir el oxígeno de una persona al año?',
    options: ['2 árboles', '7 árboles', '22 árboles'],
    correct: 1,
    funFact: 'Se necesitan aproximadamente 7 árboles para producir el oxígeno que respira una persona en un año.',
  ),
  TriviaQuestion(
    id: 3,
    category: 'naturaleza',
    question: '¿Cuál es el animal terrestre más rápido del mundo?',
    options: ['León', 'Guepardo', 'Gacela'],
    correct: 1,
    funFact: 'El guepardo puede alcanzar velocidades de hasta 120 km/h en sprints cortos.',
  ),
  TriviaQuestion(
    id: 4,
    category: 'medioambiente',
    question: '¿Cuántas veces se puede reciclar el aluminio?',
    options: ['5 veces', '20 veces', 'Infinitas veces'],
    correct: 2,
    funFact: 'El aluminio se puede reciclar infinitas veces sin perder calidad. ¡Es un material increíble!',
  ),
  TriviaQuestion(
    id: 5,
    category: 'curiosidades',
    question: '¿Qué animal puede dormir hasta 22 horas al día?',
    options: ['Oso perezoso', 'Koala', 'Gato'],
    correct: 1,
    funFact: 'Los koalas duermen entre 18-22 horas al día porque las hojas de eucalipto les dan muy poca energía.',
  ),
  TriviaQuestion(
    id: 6,
    category: 'medioambiente',
    question: '¿Qué gas es el principal responsable del efecto invernadero?',
    options: ['Oxígeno', 'Dióxido de carbono', 'Nitrógeno'],
    correct: 1,
    funFact: 'El CO₂ representa más del 75% de las emisiones de gases de efecto invernadero globales.',
  ),
  TriviaQuestion(
    id: 7,
    category: 'curiosidades',
    question: '¿Cuántas especies de insectos se estima que existen en el mundo?',
    options: ['100.000', '1 millón', '10 millones'],
    correct: 2,
    funFact: 'Se estima que existen unos 10 millones de especies de insectos, ¡y solo conocemos 1 millón!',
  ),
  TriviaQuestion(
    id: 8,
    category: 'naturaleza',
    question: '¿Cuál es el océano más grande del planeta?',
    options: ['Atlántico', 'Índico', 'Pacífico'],
    correct: 2,
    funFact: 'El Pacífico cubre más de 165 millones de km². ¡Es más grande que toda la tierra firme junta!',
  ),
  TriviaQuestion(
    id: 9,
    category: 'medioambiente',
    question: '¿Cuántas bolsas de plástico se usan cada minuto en el mundo?',
    options: ['100.000', '1 millón', '2 millones'],
    correct: 1,
    funFact: 'Se usan aproximadamente 1 millón de bolsas de plástico por minuto en todo el mundo.',
  ),
  TriviaQuestion(
    id: 10,
    category: 'curiosidades',
    question: '¿Cuánto pesa aproximadamente una ballena azul adulta?',
    options: ['50 toneladas', '100 toneladas', '150 toneladas'],
    correct: 2,
    funFact: 'Una ballena azul puede pesar hasta 150 toneladas, ¡el animal más grande que ha existido!',
  ),
  TriviaQuestion(
    id: 11,
    category: 'naturaleza',
    question: '¿Qué porcentaje del oxígeno mundial producen los océanos?',
    options: ['20%', '50%', '70%'],
    correct: 2,
    funFact: 'Los océanos producen alrededor del 70% del oxígeno mundial gracias al fitoplancton.',
  ),
  TriviaQuestion(
    id: 12,
    category: 'medioambiente',
    question: '¿Cuántos litros de agua se necesitan para producir una camiseta de algodón?',
    options: ['100 litros', '700 litros', '2.700 litros'],
    correct: 2,
    funFact: 'Se necesitan unos 2.700 litros de agua para una sola camiseta. ¡La moda tiene huella hídrica!',
  ),
  TriviaQuestion(
    id: 13,
    category: 'curiosidades',
    question: '¿Cuál es el árbol más antiguo del mundo?',
    options: ['Un roble de 1.000 años', 'Un pino de 5.000 años', 'Un olivo de 3.000 años'],
    correct: 1,
    funFact: 'El pino Matusalén tiene más de 4.850 años y vive en California. ¡Nació antes de las pirámides!',
  ),
  TriviaQuestion(
    id: 14,
    category: 'naturaleza',
    question: '¿Cuántas hormigas se estima que hay en la Tierra?',
    options: ['1 billón', '10 billones', '20 trillones'],
    correct: 2,
    funFact: 'Se estima que hay unos 20 trillones (20.000.000.000.000.000) de hormigas en la Tierra.',
  ),
  TriviaQuestion(
    id: 15,
    category: 'medioambiente',
    question: '¿Qué material tarda más en degradarse?',
    options: ['Lata de aluminio', 'Botella de vidrio', 'Pañal desechable'],
    correct: 1,
    funFact: 'Una botella de vidrio puede tardar hasta 4.000 años en degradarse, pero se recicla infinitamente.',
  ),
  TriviaQuestion(
    id: 16,
    category: 'curiosidades',
    question: '¿Pueden los pulpos cambiar de color?',
    options: ['No, es un mito', 'Sí, pero solo 2 colores', 'Sí, miles de combinaciones'],
    correct: 2,
    funFact: 'Los pulpos tienen células especiales llamadas cromatóforos que les permiten cambiar a miles de patrones.',
  ),
  TriviaQuestion(
    id: 17,
    category: 'naturaleza',
    question: '¿Cuántos km puede recorrer una mariposa monarca en su migración?',
    options: ['500 km', '2.000 km', '4.500 km'],
    correct: 2,
    funFact: 'La mariposa monarca viaja hasta 4.500 km desde Canadá hasta México cada año. ¡Increíble para su tamaño!',
  ),
];
