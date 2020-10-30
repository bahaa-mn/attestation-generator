class MotifValue {
  static const _travail = {
    "short": "Travail",
    "long":
        "Déplacements entre le domicile et le lieu d'exercice de l'activité professionnelle ou un établissement d'enseignement ou de formation, déplacements professionnels ne pouvant être différés², déplacements pour un concours ou un examen"
  };
  static const _achats = {
    "short": "Achats nécessaires",
    "long":
        "Déplacements pour effectuer des achats de fournitures nécessaires à l'activité professionnelle, des achats de première nécessité³ dans des établissements dont les activités demeurent autorisées, le retrait de commande et les livraisons à domicile"
  };
  static const _sante = {
    "short": "Consultation / soins",
    "long":
        "Consultations, examens et soins ne pouvant être assurés à distance et l'achat de médicaments"
  };
  static const _famille = {
    "short": "Famille",
    "long":
        "Déplacements pour motif familial impérieux, pour l'assistance aux personnes vulnérables et précaires ou la garde d'enfants"
  };
  static const _accompagnement = {
    "short": "Accompagnement",
    "long":
        "Déplacement des personnes en situation de handicap et leur accompagnant"
  };
  static const _promenade = {
    "short": "Promenade",
    "long":
        "Déplacements brefs, dans la limite d'une heure quotidienne et dans un rayon maximal d'un kilomètre autour du domicile, liés soit à l'activité physique individuelle des personnes, à l'exclusion de toute pratique sportive collective et de toute proximité avec d'autres personnes, soit à la promenade avec les seules personnes regroupées dans un même domicile, soit aux besoins des animaux de compagnie"
  };
  static const _convocation = {
    "short": "Convocation / service public",
    "long":
        "Convocation judiciaire ou administrative et pour se rendre dans un service public"
  };
  static const _interetGeneral = {
    "short": "Mission d'intérêt général",
    "long":
        "Participation à des missions d'intérêt général sur demande de l'autorité administrative"
  };
  static const _ecole = {
    "short": "Enfants école",
    "long":
        "Déplacement pour chercher les enfants à l'école et à l'occasion de leurs activités périscolaires"
  };

  static const list = [
    _travail,
    _achats,
    _sante,
    _famille,
    _accompagnement,
    _promenade,
    _convocation,
    _interetGeneral,
    _ecole
  ];
}

class MapAttrs {
  static const name = 'name';
  static const addresse = 'adresse';
  static const birthday = 'birthday';
  static const birthCity = 'birth-city';
  static const date = 'date';
  static const heure = 'heure';
  static const city = 'city';
  static const motif = 'motif';
  static const lastModif = 'last-modification';
}

class SharedPrefConst{

  static const listKey = 'shared-list-key';
}