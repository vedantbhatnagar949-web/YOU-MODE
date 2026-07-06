import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/neo_brutalist_container.dart';

class Topic {
  final String name;
  bool isCompleted;
  Topic({required this.name, this.isCompleted = false});
}

class SyllabusUnit {
  final String title;
  final List<Topic> topics;
  SyllabusUnit({required this.title, required this.topics});

  double get progress {
    if (topics.isEmpty) return 0.0;
    int completed = topics.where((t) => t.isCompleted).length;
    return completed / topics.length;
  }
}

class Subject {
  final String name;
  final String description;
  final List<SyllabusUnit> units;
  final Color color;
  Subject({
    required this.name,
    required this.description,
    required this.units,
    required this.color,
  });

  double get progress {
    if (units.isEmpty) return 0.0;
    double totalProgress = units.fold(0.0, (sum, unit) => sum + unit.progress);
    return totalProgress / units.length;
  }
}

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final List<Subject> syllabus = [
    Subject(
      name: '1. Physics (NCERT)',
      description: 'The Class 11 Physics syllabus shifts focus from basic science to intense mathematical application, calculus-based derivations, and mechanics.',
      color: AppTheme.primary,
      units: [
        SyllabusUnit(title: 'Unit I: Physical World and Measurement', topics: [
          Topic(name: 'Units and Measurements'),
          Topic(name: 'SI units, dimensional analysis, errors in measurement'),
        ]),
        SyllabusUnit(title: 'Unit II: Kinematics', topics: [
          Topic(name: 'Motion in a Straight Line (Frame of reference, v-t graphs, calculus formulas)'),
          Topic(name: 'Motion in a Plane (Vectors, scalar products, projectile motion, uniform circular motion)'),
        ]),
        SyllabusUnit(title: 'Unit III: Laws of Motion', topics: [
          Topic(name: 'Newton’s Laws of Motion'),
          Topic(name: 'Momentum, impulse, friction mechanics'),
          Topic(name: 'Dynamics of uniform circular motion (banking of roads)'),
        ]),
        SyllabusUnit(title: 'Unit IV: Work, Energy, and Power', topics: [
          Topic(name: 'Work-Energy Theorem'),
          Topic(name: 'Kinetic/potential energy, conservative forces'),
          Topic(name: 'Elastic and inelastic collisions'),
        ]),
        SyllabusUnit(title: 'Unit V: Motion of System of Particles and Rigid Body', topics: [
          Topic(name: 'Centre of mass, torque, angular momentum'),
          Topic(name: 'Rotational dynamics, moment of inertia'),
          Topic(name: 'Parallel and perpendicular axis theorems'),
        ]),
        SyllabusUnit(title: 'Unit VI: Gravitation', topics: [
          Topic(name: 'Kepler’s laws, Universal law of gravitation'),
          Topic(name: 'Acceleration due to gravity (g) with altitude/depth'),
          Topic(name: 'Escape velocity, satellite orbital velocity'),
        ]),
        SyllabusUnit(title: 'Unit VII: Properties of Bulk Matter', topics: [
          Topic(name: 'Mechanical Properties of Solids (Hooke’s law, Young’s modulus, stress-strain curves)'),
          Topic(name: 'Mechanical Properties of Fluids (Pascal\'s law, Bernoulli’s theorem, viscosity, surface tension)'),
          Topic(name: 'Thermal Properties of Matter (Heat, temperature, thermal expansion, specific heat capacity)'),
        ]),
        SyllabusUnit(title: 'Unit VIII: Thermodynamics', topics: [
          Topic(name: 'Thermal equilibrium'),
          Topic(name: 'Zeroth, First, and Second laws of thermodynamics'),
          Topic(name: 'Isothermal and adiabatic processes'),
        ]),
        SyllabusUnit(title: 'Unit IX: Kinetic Theory of Gases', topics: [
          Topic(name: 'Equation of state of a perfect gas'),
          Topic(name: 'Work done on compression'),
          Topic(name: 'Kinetic interpretation of temperature, degrees of freedom, specific heat capacities'),
        ]),
        SyllabusUnit(title: 'Unit X: Oscillations and Waves', topics: [
          Topic(name: 'Simple Harmonic Motion (SHM)'),
          Topic(name: 'Wave motion, longitudinal/transverse waves'),
          Topic(name: 'Speed of travel, displacement relation for a progressive wave'),
        ]),
      ],
    ),
    Subject(
      name: '2. Chemistry (NCERT)',
      description: 'The syllabus is divided equally into Physical, Inorganic, and Organic Chemistry foundations.',
      color: AppTheme.secondary,
      units: [
        SyllabusUnit(title: 'Unit I: Some Basic Concepts of Chemistry', topics: [
          Topic(name: 'Mole concept, atomic/molecular masses'),
          Topic(name: 'Stoichiometry, empirical and molecular formulas'),
        ]),
        SyllabusUnit(title: 'Unit II: Structure of Atom', topics: [
          Topic(name: 'Bohr’s model, dual nature of matter (de Broglie), Heisenberg uncertainty principle'),
          Topic(name: 'Quantum numbers, Aufbau principle, Pauli exclusion principle, Hund\'s rule'),
        ]),
        SyllabusUnit(title: 'Unit III: Classification of Elements and Periodicity in Properties', topics: [
          Topic(name: 'Modern periodic law'),
          Topic(name: 'Periodic trends in properties (ionization enthalpy, electron gain enthalpy, atomic radii, electronegativity)'),
        ]),
        SyllabusUnit(title: 'Unit IV: Chemical Bonding and Molecular Structure', topics: [
          Topic(name: 'Ionic and covalent bonds, Valence Bond Theory (VBT)'),
          Topic(name: 'Hybridization (sp, sp2, sp3), VSEPR theory (molecular shapes)'),
          Topic(name: 'Molecular Orbital Theory (MOT) for homonuclear diatomic molecules'),
        ]),
        SyllabusUnit(title: 'Unit V: Chemical Thermodynamics', topics: [
          Topic(name: 'First law, internal energy, enthalpy (H), heat capacity'),
          Topic(name: 'Hess’s law, entropy (S), Gibbs free energy (G), spontaneity conditions'),
        ]),
        SyllabusUnit(title: 'Unit VI: Equilibrium', topics: [
          Topic(name: 'Equilibrium in physical & chemical processes, Law of mass action'),
          Topic(name: 'Le Chatelier’s principle'),
          Topic(name: 'Ionic equilibrium (pH, ionization of weak acids/bases, solubility product)'),
        ]),
        SyllabusUnit(title: 'Unit VII: Redox Reactions', topics: [
          Topic(name: 'Oxidation and reduction concepts, oxidation numbers'),
          Topic(name: 'Balancing redox equations (ion-electron and oxidation number methods)'),
        ]),
        SyllabusUnit(title: 'Unit VIII: Organic Chemistry', topics: [
          Topic(name: 'IUPAC nomenclature'),
          Topic(name: 'Electronic displacement effects (inductive, electromeric, resonance, hyperconjugation)'),
          Topic(name: 'Homolytic/heterolytic fission, purification techniques'),
        ]),
        SyllabusUnit(title: 'Unit IX: Hydrocarbons', topics: [
          Topic(name: 'Alkanes, Alkenes, Alkynes (nomenclature, isomerism, physical properties, chemical reactions)'),
          Topic(name: 'Aromatic Hydrocarbons (benzene structure, aromaticity, mechanism of electrophilic substitution)'),
        ]),
      ],
    ),
    Subject(
      name: '3. Mathematics (NCERT)',
      description: 'Math forms the operational backbone for physics and features an introduction to abstract algebraic structures and calculus.',
      color: AppTheme.tertiary,
      units: [
        SyllabusUnit(title: 'Unit I: Sets and Functions', topics: [
          Topic(name: 'Sets (Representations, empty/finite/infinite sets, subsets, Venn diagrams, operations)'),
          Topic(name: 'Relations and Functions (Ordered pairs, Cartesian product, domain/co-domain/range, standard graphs)'),
          Topic(name: 'Trigonometric Functions (Positive/negative angles, radian/degree conversion, identities)'),
        ]),
        SyllabusUnit(title: 'Unit II: Algebra', topics: [
          Topic(name: 'Complex Numbers and Quadratic Equations'),
          Topic(name: 'Linear Inequalities'),
          Topic(name: 'Permutations and Combinations'),
          Topic(name: 'Binomial Theorem'),
          Topic(name: 'Sequence and Series (AP, GP)'),
        ]),
        SyllabusUnit(title: 'Unit III: Coordinate Geometry', topics: [
          Topic(name: 'Straight Lines (Slope, forms of equations of a line, distance of a point from a line)'),
          Topic(name: 'Conic Sections (Standard equations and properties of circles, ellipses, parabolas, hyperbolas)'),
          Topic(name: 'Introduction to Three-Dimensional Geometry'),
        ]),
        SyllabusUnit(title: 'Unit IV: Calculus', topics: [
          Topic(name: 'Limits and Derivatives (Intuitive idea of limits, product and quotient rules)'),
        ]),
        SyllabusUnit(title: 'Unit V: Statistics and Probability', topics: [
          Topic(name: 'Statistics (Measures of dispersion, range, mean deviation, variance, standard deviation)'),
          Topic(name: 'Probability (Random experiments, sample spaces, events, axiomatic probability approach)'),
        ]),
      ],
    ),
    Subject(
      name: '4. Computer Science',
      description: 'Strictly adapts the CBSE CS syllabus, focusing heavily on logical problem-solving and programming in Python.',
      color: AppTheme.accent,
      units: [
        SyllabusUnit(title: 'Unit I: Computer Systems and Organisation', topics: [
          Topic(name: 'Basic computer organization: CPU, memory, hard drive, I/O devices'),
          Topic(name: 'Types of software: System software, application software, utility software'),
          Topic(name: 'Data representation: Number systems and conversion logic'),
          Topic(name: 'Boolean Logic: AND, OR, NOT, NAND, NOR, XOR gates, De Morgan’s Laws'),
        ]),
        SyllabusUnit(title: 'Unit II: Computational Thinking and Programming – 1', topics: [
          Topic(name: 'Introduction to problem-solving using flowcharts and pseudocode'),
          Topic(name: 'Getting Started with Python: Interactive vs script mode, variables, keywords, data types'),
          Topic(name: 'Operators: Arithmetic, relational, logical, assignment, and bitwise operators'),
          Topic(name: 'Flow of Control: conditional statements, loops'),
          Topic(name: 'Strings, Lists, Tuples, Dictionaries, and Python Modules'),
        ]),
        SyllabusUnit(title: 'Unit III: Society, Law and Ethics', topics: [
          Topic(name: 'Digital footprint, netiquette, data privacy, intellectual property rights (IPR)'),
          Topic(name: 'Cybercrime, cyber safety, e-waste management, and IT Act basics'),
        ]),
      ],
    ),
    Subject(
      name: '5. English Core (NCERT)',
      description: 'Evaluated across Reading, Writing, Grammar, and Literature textbooks.',
      color: const Color(0xFFFFB800), // Custom color for the fifth item
      units: [
        SyllabusUnit(title: 'Reading Skills', topics: [
          Topic(name: 'Unseen passages (factual, descriptive, or literary)'),
          Topic(name: 'Note-making/Summarizing based on a passage'),
        ]),
        SyllabusUnit(title: 'Creative Writing Skills', topics: [
          Topic(name: 'Short writing tasks (Posters, Advertisements, Notices)'),
          Topic(name: 'Long writing tasks (Speech writing, Debate writing)'),
        ]),
        SyllabusUnit(title: 'Grammar', topics: [
          Topic(name: 'Tenses, Re-ordering/transformation of sentences, gap filling'),
        ]),
        SyllabusUnit(title: 'Literature Textbooks', topics: [
          Topic(name: 'Hornbill (Prose & Poetry): The Portrait of a Lady, A Photograph, “We’re Not Afraid to Die...”'),
          Topic(name: 'Hornbill: Discovering Tut, The Laburnum Top, The Voice of the Rain, The Adventure, Silk Road, Father to Son'),
          Topic(name: 'Snapshots: The Summer of the Beautiful White Horse, The Address, Mother’s Day, Birth, The Tale of Melon City'),
        ]),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Syllabus', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: AppTheme.background,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(
            color: AppTheme.border,
            height: 3.0,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: syllabus.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final subject = syllabus[index];
          return _buildSubjectCard(subject);
        },
      ),
    );
  }

  Widget _buildSubjectCard(Subject subject) {
    return NeoBrutalistContainer(
      backgroundColor: subject.color,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          iconColor: Colors.black,
          collapsedIconColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subject.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 24, // Use headlineMedium but scale down slightly
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.black),
                ),
                child: Text(
                  '${(subject.progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: subject.color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subject.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          children: subject.units.map((unit) {
            return Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border.all(color: AppTheme.border, width: 3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          unit.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: subject.color,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Text(
                        '${(unit.progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppTheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: unit.progress,
                    backgroundColor: Colors.black,
                    color: subject.color,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 16),
                  ...unit.topics.map((topic) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            topic.isCompleted = !topic.isCompleted;
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              topic.isCompleted
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: topic.isCompleted ? subject.color : AppTheme.onSurface,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                topic.name,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      decoration: topic.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: topic.isCompleted
                                          ? AppTheme.onSurface.withOpacity(0.5)
                                          : AppTheme.onSurface,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
