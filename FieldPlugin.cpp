#include "FieldPlugin.h"
#include <qqml.h>


void FieldPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<Field>(uri, 1, 0, "FieldModel");
}
