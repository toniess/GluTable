#ifndef SUBJECTSETTINGS_H
#define SUBJECTSETTINGS_H

#include <QObject>
#include <QVariant>

class SubjectSettings : public QObject
{
    Q_OBJECT
public:
    SubjectSettings();
    void fillFromFolder();
private:
    QString getLinkFromSubjectName(QString subjectName);
public slots:
    void saveSubjectSettings(QVariant subjectSettingsName, QVariant subjectSettingsArray);
    void showSubjects(QVariant subjectName);
    void addNewSubjectSet();
    bool renameSubjectSet(QVariant lastName, QVariant newName);
    void deleteSubjectSet(QVariant subjectSettingName);
    void fillTableCollumn(QVariant subjectName, QVariant table, QVariant collumn);
    QVariant getSubjectDb();
signals:
    void addSubject(QVariant subjectName);
    void clearSubjectModel();
    void clearMenuListSig();
    void addMenuListSig(QVariant subjectName);
    void addSubjectSetting(QVariant subjectSettingName, QVariant subjectSettingValue);
    void setTableCollumn(QVariant table, QVariant collumn, QVariant subject);
};

#endif // SUBJECTSETTINGS_H
