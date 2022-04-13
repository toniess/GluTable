#ifndef TEACHERSETTINGS_H
#define TEACHERSETTINGS_H

#include <QObject>
#include <QVariant>

class TeacherSettings : public QObject
{
    Q_OBJECT
public:
    TeacherSettings();
    void fillFromFolder();
public slots:
    void addTeacher();
    void showTeacherProfile(QVariant teacherName);
    void saveTeacherProfile(QVariant teacherName, QVariant profile);
    void delTeacher(QVariant teacherName);
    bool renameTeacher(QVariant lastName, QVariant newName);
    QVariant getSubjectProfiled(QVariant subject);
signals:
    void addTeacherSetting(QVariant teacherName);
    void addNewTeacher(QVariant teacherName);
    void addTeacherProfileLine(QVariant subject);
    void clearContextMenu();
    void addInContexMenu(QVariant teacherName);
};

#endif // TEACHERSETTINGS_H
