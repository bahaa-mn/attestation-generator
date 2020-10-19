class Attestation {
  final String id;
  final DateTime date;
  final List<int> motifs;

  Attestation({
    this.id,
    this.date,
    this.motifs,
  }) : assert(date != null && motifs.length >= 1);
  
}
