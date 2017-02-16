import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0
import "utils.js" as Utils

ApplicationWindow  {
	visible: true
	width: 640
	height: 480
	title: qsTr("File Dialog")
	ChooseFileViewer {
		anchors.fill: parent
	}
}
