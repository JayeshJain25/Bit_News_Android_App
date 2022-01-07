class ContactUsModel {
  final String projectName;
  final String emailId;
  final String projectWebsite;
  final String projectDescription;
  final String budget;

  const ContactUsModel({
    required this.projectName,
    required this.emailId,
    required this.projectWebsite,
    required this.projectDescription,
    required this.budget,
  });

  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(
      projectName: json['projectName'] as String,
      emailId: json['emailId'] as String,
      projectWebsite: json['projectWebsite'] as String,
      projectDescription: json['projectDescription'] as String,
      budget: json['budget'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'emailId': emailId,
        'projectWebsite': projectWebsite,
        'projectDescription': projectDescription,
        'budget': budget,
      };
}
