#include "qmltranslator.h"
#include <QApplication>


QmlTranslator::QmlTranslator(QObject *parent)
{

}

void QmlTranslator::setTranslation(QString translation)
{
    m_translator.load(":/language/QmlLanguage_ru_RU.qm");

    qApp->installTranslator(&m_translator);
    emit languageChanged();
}
