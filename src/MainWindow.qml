import org.hildon.components 1.0
import org.hildon.utils 1.0

Window {
    id: window
    
    windowTitle: "QML Screenshot"
    orientationLock: Screen.AutoOrientation
    tools: [
        Action {
            text: delayTimer.running ? qsTr("Cancel screenshot") : qsTr("Take screenshot")
            onTriggered: delayTimer.running ? delayTimer.stop() : delayTimer.restart()
        },
        
        Action {
            text: qsTr("Reset settings")
            onTriggered: {
                targetXSpinBox.value = 0;
                targetYSpinBox.value = 0;
                targetWidthSpinBox.value = -1;
                targetHeightSpinBox.value = -1;
                imageWidthSpinBox.value = -1;
                imageHeightSpinBox.value = -1;
                delaySpinBox.value = 0;
            }
        },
        
        Action {
            text: qsTr("About")
            onTriggered: {
                loader.sourceComponent = aboutDialog;
                loader.item.open();
            }
        }
    ]
    
    Flickable {
        id: flicker
        
        anchors {
            fill: parent
            margins: platformStyle.paddingMedium
        }
        
        Grid {
            id: grid
            
            columns: window.inPortrait ? 1 : 2
            
            Label {
                text: qsTr("Target x") + ":"
            }
            
            SpinBox {
                id: targetXSpinBox
                
                minimum: 0
                maximum: screen.width - 1
                suffix: " px"
            }
            
            Label {
                text: qsTr("Target y") + ":"
            }
            
            SpinBox {
                id: targetYSpinBox
                
                minimum: 0
                maximum: screen.height - 1
                suffix: " px"
            }
            
            Label {
                text: qsTr("Target width (-1 is screen width)") + ":"
            }
            
            SpinBox {
                id: targetWidthSpinBox
                
                minimum: -1
                maximum: screen.width - targetXSpinBox.value
                value: -1
                suffix: " px"
            }
            
            Label {
                text: qsTr("Target height (-1 is screen height)") + ":"
            }
            
            SpinBox {
                id: targetHeightSpinBox
                
                minimum: -1
                maximum: screen.height - targetYSpinBox.value
                value: -1
                suffix: " px"
            }
            
            Label {
                text: qsTr("Image width (-1 is target width)") + ":"
            }
            
            SpinBox {
                id: imageWidthSpinBox
                
                minimum: -1
                maximum: screen.width
                value: -1
                suffix: " px"
            }
            
            Label {
                text: qsTr("Image height (-1 is target height)") + ":"
            }
            
            SpinBox {
                id: imageHeightSpinBox
                
                minimum: -1
                maximum: screen.height
                value: -1
                suffix: " px"
            }
            
            Label {
                text: qsTr("Screenshot delay") + ":"
            }
            
            SpinBox {
                id: delaySpinBox
                
                minimum: 0
                maximum: 60000
                singleStep: 1000
                suffix: " ms"
            }
            
            CheckBox {
                id: repeatCheckBox
                
                text: qsTr("Take repeat screenshots")
                enabled: delaySpinBox.value > 0
                onEnabledChanged: if (!enabled) checked = false;
            }
            
            ValueButton {
                id: locationButton
                
                text: qsTr("Storage location")
                valueText: "/home/user/MyDocs/.images/Screenshots/"
                onClicked: {
                    loader.sourceComponent = folderDialog;
                    loader.item.open();
                }
            }
        }
    }
    
    Loader {
        id: loader
    }
    
    Component {
        id: folderDialog
        
        FolderDialog {
            onSelected: locationButton.valueText = folder[folder.length - 1] == "/" ? folder : folder + "/"
            onVisibleChanged: if (visible) cd(locationButton.valueText);
        }
    }
    
    Component {
        id: infobox
        
        InformationBox {
            minimumHeight: 120
            timeout: InformationBox.NoTimeout
            content: Label {
                anchors {
                    fill: parent
                    leftMargin: 100
                }
                alignment: Qt.AlignVCenter
                color: platformStyle.reversedTextColor
                text: qsTr("Cannot save screenshot")
            }
        }
    }
    
    Component {
        id: aboutDialog
        
        Dialog {
            windowTitle: qsTr("About")
            height: window.inPortrait ? 300 : 200
            content: Column {
                anchors.fill: parent

                Row {

                    Image {
                        width: 64
                        height: 64
                        source: "file:///usr/share/icons/hicolor/64x64/apps/qml-screenshot.png"
                    }

                    Label {
                        font.bold: true
                        font.pixelSize: platformStyle.fontSizeLarge
                        text: "QML Screenshot 0.0.1"
                    }
                }

                Label {
                    wordWrap: true
                    text: qsTr("A simple screenshot application written using")
                          + " Qt Components Hildon.<br><br>&copy; Stuart Howarth 2014"
                }
            }
        }
    }
    
    Timer {
        id: delayTimer
        
        interval: delaySpinBox.value
        repeat: repeatCheckBox.checked
        onTriggered: {
            directory.mkpath(locationButton.valueText);
            screenshot.fileName = locationButton.valueText
                                  + "Screenshot-"
                                  + Qt.formatDateTime(new Date(), "yyyyMMdd-hhmmss")
                                  + ".png";
            
            if (!screenshot.grab()) {
                stop();
                loader.sourceComponent = infobox;
                loader.item.open();
            }
        }
    }
    
    Directory {
        id: directory
    }
    
    ScreenShot {
        id: screenshot
        
        targetX: targetXSpinBox.value
        targetY: targetYSpinBox.value
        targetWidth: targetWidthSpinBox.value
        targetHeight: targetHeightSpinBox.value
        width: imageWidthSpinBox.value
        height: imageHeightSpinBox.value
        smooth: true
    }
}

