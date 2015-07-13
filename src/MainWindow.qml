/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 1.0
import org.hildon.components 1.0
import org.hildon.utils 1.0

Window {
    id: window
    
    visible: true
    title: "QML Screenshot"
    orientationLock: Qt.WA_Maemo5AutoOrientation
    menuBar: MenuBar {
        MenuItem {
            text: delayTimer.running ? qsTr("Cancel screenshot") : qsTr("Take screenshot")
            onTriggered: delayTimer.running ? delayTimer.stop() : delayTimer.restart()
        }
        
        MenuItem {
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
        }
        
        MenuItem {
            text: qsTr("About")
            onTriggered: dialogs.showAboutDialog()
        }
    }
    
    Flickable {
        id: flicker
        
        anchors.fill: parent
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        contentHeight: grid.height + platformStyle.paddingMedium
        
        Grid {
            id: grid
            
            property int itemWidth: columns == 1 ? width : Math.floor((width - spacing) / 2)
            
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: platformStyle.paddingMedium
            }
            columns: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation ? 1 : 2
            spacing: platformStyle.paddingMedium
            
            Label {
                width: grid.itemWidth
                height: 70
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Target x") + ":"
            }
            
            SpinBox {
                id: targetXSpinBox
                
                width: grid.itemWidth
                minimum: 0
                maximum: screen.width - 1
                suffix: " px"
            }
            
            Label {
                width: grid.itemWidth
                height: 70
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Target y") + ":"
            }
            
            SpinBox {
                id: targetYSpinBox
                
                width: grid.itemWidth
                minimum: 0
                maximum: screen.height - 1
                suffix: " px"
            }
            
            Label {
                width: grid.itemWidth
                height: 70
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Target width (-1 is screen width)") + ":"
            }
            
            SpinBox {
                id: targetWidthSpinBox
                
                width: grid.itemWidth
                minimum: -1
                maximum: screen.width - targetXSpinBox.value
                value: -1
                suffix: " px"
            }
            
            Label {
                width: grid.itemWidth
                height: 70
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Target height (-1 is screen height)") + ":"
            }
            
            SpinBox {
                id: targetHeightSpinBox
                
                width: grid.itemWidth
                minimum: -1
                maximum: screen.height - targetYSpinBox.value
                value: -1
                suffix: " px"
            }
            
            Label {
                width: grid.itemWidth
                height: 70
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Image width (-1 is target width)") + ":"
            }
            
            SpinBox {
                id: imageWidthSpinBox
                
                width: grid.itemWidth
                minimum: -1
                maximum: screen.width
                value: -1
                suffix: " px"
            }
            
            Label {
                width: grid.itemWidth
                height: 70
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Image height (-1 is target height)") + ":"
            }
            
            SpinBox {
                id: imageHeightSpinBox
                
                width: grid.itemWidth
                minimum: -1
                maximum: screen.height
                value: -1
                suffix: " px"
            }
            
            Label {
                width: grid.itemWidth
                height: 70
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Screenshot delay") + ":"
            }
            
            SpinBox {
                id: delaySpinBox
                
                width: grid.itemWidth
                minimum: 0
                maximum: 60000
                singleStep: 1000
                suffix: " ms"
            }
            
            CheckBox {
                id: repeatCheckBox
                
                width: grid.itemWidth
                text: qsTr("Take repeat screenshots")
                enabled: delaySpinBox.value > 0
                onEnabledChanged: if (!enabled) checked = false;
            }
            
            ValueButton {
                id: locationButton
                
                width: grid.itemWidth
                text: qsTr("Storage location")
                valueText: "/home/user/MyDocs/.images/Screenshots/"
                onClicked: dialogs.showFileDialog()
            }
        }
    }
    
    QtObject {
        id: dialogs
        
        property Dialog aboutDialog
        property FileDialog fileDialog
        property InformationBox informationBox
        
        function showAboutDialog() {
            if (!aboutDialog) {
                aboutDialog = aboutDialogComponent.createObject(window);
            }
            
            aboutDialog.open();
        }
        
        function showFileDialog() {
            if (!fileDialog) {
                fileDialog = fileDialogComponent.createObject(window);
            }
            
            fileDialog.open();
        }
        
        function showInformationBox() {
            if (!informationBox) {
                informationBox = informationBoxComponent.createObject(window);
            }
            
            informationBox.open();
        }
    }
    
    Component {
        id: fileDialogComponent
        
        FileDialog {
            selectFolder: true
            folder: locationButton.valueText
            onAccepted: locationButton.valueText = folder[folder.length - 1] == "/" ? folder : folder + "/"
        }
    }
    
    Component {
        id: informationBoxComponent
        
        InformationBox {
            height: infoLabel.height + platformStyle.paddingLarge
            
            Label {
                id: infoLabel
                
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    margins: platformStyle.paddingLarge
                }
                horizontalAlignment: Text.AlignHCenter
                color: platformStyle.reversedTextColor
                text: qsTr("Cannot save screenshot")
            }
        }
    }
    
    Component {
        id: aboutDialogComponent
        
        Dialog {
            title: qsTr("About")
            height: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation ? 300 : 200
            
            Column {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                spacing: platformStyle.paddingMedium

                Row {
                    width: parent.width
                    spacing: platformStyle.paddingMedium
                    
                    Image {
                        width: 64
                        height: 64
                        source: "image://icon/qml-screenshot"
                    }

                    Label {
                        height: 64
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        font.pointSize: platformStyle.fontSizeLarge
                        text: "QML Screenshot 0.0.2"
                    }
                }

                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr("A simple screenshot application written using")
                          + " Qt Components Hildon.<br><br>&copy; Stuart Howarth 2015"
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
                dialogs.showInformationBox();
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

