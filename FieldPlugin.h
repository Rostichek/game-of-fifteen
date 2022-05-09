#ifndef FIELDPLUGIN_H
#define FIELDPLUGIN_H

#include <QQmlExtensionPlugin>
#include "field.h"

class FieldPlugin: public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char *uri);
};

#endif // FIELDPLUGIN_H
