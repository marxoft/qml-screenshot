TEMPLATE = subdirs

qml.files = src/MainWindow.qml
qml.path = /opt/qml-screenshot/qml

desktop.files = desktop/qml-screenshot.desktop
desktop.path = /usr/share/applications/hildon

icon.files = desktop/qml-screenshot.png
icon.path = /usr/share/icons/hicolor/64x64/apps

INSTALLS += qml desktop icon
