/**
MIT License

Copyright (c) 2017 Andrey Semenov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import QtQuick 2.0
import QtQuick.Controls 1.4 as OldControls
import QtQuick.Controls 2.1
import QtQml.Models 2.2
import Qt.labs.folderlistmodel 2.1
import QtQuick.Window 2.0
import "utils.js" as Utils
import QtQuick.Dialogs 1.2

Item {
	readonly property real textmargin: Utils.dp(Screen.pixelDensity,8)
	function isFolder(fileName) {
		return folderListModel.isFolder(folderListModel.indexOf(folderListModel.folder + "/" + fileName));
	}
	function canMoveUp() {
		if(folderListModel.folder.toString() === "file:///") {
			return false;
		}
		return true;
	}

	function onItemClick(fileName) {
		if(!isFolder(fileName)) {
			messageDialog.text = "Cannot open file "+ fileName
			messageDialog.open()
			return;
		}
		if(fileName === ".." && canMoveUp()) {
			folderListModel.folder = folderListModel.parentFolder
		} else if(fileName !== ".") {
			if(folderListModel.folder.toString() === "file:///") {
				folderListModel.folder += fileName
			} else {
				folderListModel.folder += "/" + fileName
			}
		}
	}
	MessageDialog {
		id: messageDialog
		standardButtons: StandardButton.Ok
	}
	Rectangle {
		id: toolbar
		anchors.right: parent.right
		anchors.left: parent.left
		anchors.top: parent.top
		height: Utils.dp(Screen.pixelDensity, 48)
		color: Utils.backgroundColor()
		Button {
			id: button
			text: ".."
			anchors.right: parent.right
			anchors.rightMargin: Utils.dp(Screen.pixelDensity, 24)
			anchors.bottom: parent.bottom
			anchors.top: parent.top
			enabled: canMoveUp()
			flat: true
			onClicked: {
				if(canMoveUp) {
					folderListModel.folder = folderListModel.parentFolder
				}
			}
		}
		Text {
			id: filePath
			text: folderListModel.folder.toString().replace("file:///", "►").replace("/", "►").replace("/", "►").replace("/", "►").replace("/", "►")
			renderType: Text.NativeRendering
			elide: Text.ElideMiddle
			anchors.right: button.left
			font.italic: true
			font.bold: true
			verticalAlignment: Text.AlignVCenter
			anchors.left: parent.left
			anchors.leftMargin: Utils.dp(Screen.pixelDensity, 24)
			anchors.bottom: parent.bottom
			anchors.top: parent.top
			font.pixelSize: Utils.dp(Screen.pixelDensity, 10)

		}
	}

	FolderListModel {
		id:  folderListModel
//		showDotAndDotDot: true
		showHidden: true
		showDirsFirst: true
		//		folder: "file:///sdcard"
		nameFilters: "*.*"
	}
	OldControls.TableView {
		id: view
		anchors.top: toolbar.bottom
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		model: folderListModel
		headerDelegate:headerDelegate
		rowDelegate: Rectangle {
			height: Utils.dp(Screen.pixelDensity, 40)
		}

		OldControls.TableViewColumn {
			title: qsTr("FileName")
			role: "fileName"
			resizable: true
			delegate: fileDelegate
		}

		Component {
			id: fileDelegate
			Item {
				height: Utils.dp(Screen.pixelDensity,36)
				Rectangle {
					anchors.fill: parent
					MouseArea {
						anchors.fill: parent
						onClicked: {
							onItemClick(fileNameText.text)
						}
					}
					Text {
						id: fileNameText
						height: width
						anchors.left: image.right
						anchors.top: parent.top
						anchors.bottom: parent.bottom
						anchors.right: parent.right
						text: styleData.value !== undefined ? styleData.value : ""
						verticalAlignment: Text.AlignVCenter
					}
					Image {
						id: image
						width: Utils.dp(Screen.pixelDensity,24)
						height: width
						anchors.left: parent.left
						anchors.leftMargin: textmargin
						anchors.verticalCenter: parent.verticalCenter
						source: isFolder(fileNameText.text) ? "qrc:/icons/ic_folder_open_black_48dp.png" : "qrc:/icons/ic_insert_drive_file_black_48dp.png"
					}
				}
			}
		}
		Component {
			id: headerDelegate
			Rectangle {
				height: Utils.dp(Screen.pixelDensity, 36)
				color: Utils.textAltColor()
				border.color: Utils.textAltColor()
				Text {
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter
					height: Utils.dp(Screen.pixelDensity, 12)
					font.bold: true
					elide: Text.ElideMiddle
					color: Utils.primaryColor()
					text: styleData.value !== undefined ? styleData.value : ""
				}
			}
		}
	}
}
