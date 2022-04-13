#ifndef HOMEPAGE_H
#define HOMEPAGE_H

#include <QObject>
#include <QVariant>

class HomePage : public QObject
{
    Q_OBJECT
public:
    HomePage();
    ~HomePage();

    void updateTables();
    void fillFromFolder();

public slots:
    void saveTable(QVariant companyTablePos, QVariant dataToSave);
    void deleteTable(QVariant tableName);
    void addNewTable(QVariant tableName);
    bool fillWorkSpace(QVariant tableName);
    void createCompanyTable(QVariant companyTablePos);
    void addCompanyTableToFile(QVariant companyTablePos);
    void deleteCompanyTable(QVariant companyTablePos);
    bool fileOpened();

protected:
    QString getTableNameFromLink(QString tableNameLink);
    QString getLinkFromTableName(QString tableName);
    QString currentTableName;
    void fillWithTableItems(int companyTablePos, QString fileName);
    QStringList getConfigList(QString fileName);

signals:
    void addTable(QVariant tableName);
    void setTableItem(QVariant subject, QVariant teacher, QVariant row, QVariant col);
    void addTableItem(QVariant tableIndex, QVariant subject, QVariant widthSpan, QVariant heightSpan,
                      QVariant isBold, QVariant row, QVariant collumn, QVariant teacherName);
    void clearWorkSpace();
    void setStatusBarName(QVariant tableName);
    void showMessage(QString header, QString message);

    void addCompanyTable(int companyTablePos);
    void openEditPage();
};

#endif // HOMEPAGE_H
