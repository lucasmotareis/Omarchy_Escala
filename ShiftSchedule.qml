import QtQuick
import qs.Commons
import qs.Commons as Commons
import qs.Ui
import "ShiftModel.js" as ShiftModel

// Compact schedule controls under the month grid. A normal day click keeps
// its calendar meaning; the action here changes only the selected day.
Column {
  id: root

  property color foreground: Commons.Color.foreground
  property string fontFamily: Style.font.family
  property string language: "pt"
  property string todayKey: ""
  property string selectedDayKey: ""
  property string anchor: ""
  property int serviceDays: 2
  property int offDays: 6
  property var overrides: ({})
  property bool editing: false
  property string errorText: ""

  signal scheduleSaved(string anchor, int serviceDays, int offDays)
  signal selectedDayToggled(string key)
  signal editingFinished()

  readonly property string nextKey: ShiftModel.nextService(todayKey, anchor, serviceDays, offDays, overrides)
  readonly property string selectedStatus: ShiftModel.status(selectedDayKey, anchor, serviceDays, offDays, overrides)
  readonly property bool selectedException: !!overrides[selectedDayKey]

  spacing: Style.space(6)

  function isPortuguese() { return language === "pt" }
  function dateLabel(key) {
    return /^\d{4}-\d{2}-\d{2}$/.test(key) ? key.substr(8, 2) + "/" + key.substr(5, 2) + "/" + key.substr(0, 4) : key
  }

  function edit() {
    errorText = ""
    editing = true
    anchorField.text = anchor || todayKey
    onField.text = String(serviceDays)
    offField.text = String(offDays)
    anchorField.forceActiveFocus()
    anchorField.selectAll()
  }

  function save() {
    var date = String(anchorField.text).trim()
    var on = String(onField.text).trim()
    var off = String(offField.text).trim()
    if (ShiftModel.dayNumber(date) === null || !/^[1-9]\d*$/.test(on) || !/^[1-9]\d*$/.test(off)
        || Number(on) > 365 || Number(off) > 365) {
      errorText = isPortuguese()
        ? "Use data AAAA-MM-DD e números entre 1 e 365."
        : "Use YYYY-MM-DD and numbers from 1 to 365."
      return
    }
    scheduleSaved(date, Number(on), Number(off))
    editing = false
    errorText = ""
    editingFinished()
  }

  function cancel() {
    editing = false
    errorText = ""
    editingFinished()
  }

  Text {
    width: parent.width
    textFormat: Text.PlainText
    text: root.nextKey
      ? (root.isPortuguese() ? "PRÓXIMO SERVIÇO  " : "NEXT SHIFT  ") + root.dateLabel(root.nextKey)
      : (root.isPortuguese() ? "CONFIGURE A ESCALA DE SERVIÇO" : "SET UP YOUR SHIFT SCHEDULE")
    color: Commons.Color.accent
    font.family: root.fontFamily
    font.pixelSize: Style.font.body
    font.bold: true
    horizontalAlignment: Text.AlignHCenter
  }

  Text {
    width: parent.width
    textFormat: Text.PlainText
    text: root.anchor
      ? root.serviceDays + (root.isPortuguese() ? " serviço / " : " on / ") + root.offDays + (root.isPortuguese() ? " folga" : " off")
      : (root.isPortuguese() ? "Informe o primeiro dia de serviço" : "Enter the first shift day")
    color: Util.alpha(root.foreground, 0.72)
    font.family: root.fontFamily
    font.pixelSize: Style.font.bodySmall
    horizontalAlignment: Text.AlignHCenter
  }

  Row {
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: Style.space(6)

    SecondaryButton {
      text: root.isPortuguese() ? "Configurar" : "Configure"
      foreground: root.foreground
      fontFamily: root.fontFamily
      onClicked: root.edit()
    }

    SecondaryButton {
      enabled: root.selectedDayKey !== ""
      text: root.selectedException
        ? (root.isPortuguese() ? "Remover avulso" : "Remove exception")
        : root.selectedStatus === "service"
          ? (root.isPortuguese() ? "Marcar folga" : "Mark off")
          : (root.isPortuguese() ? "Serviço avulso" : "Extra shift")
      tooltipText: root.isPortuguese()
        ? "Altera apenas o dia selecionado; a sequência permanece igual."
        : "Changes only the selected day; the cycle stays the same."
      foreground: root.foreground
      fontFamily: root.fontFamily
      onClicked: root.selectedDayToggled(root.selectedDayKey)
    }
  }

  Row {
    visible: root.editing
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: Style.space(6)

    TextField {
      id: anchorField
      width: Style.space(112)
      placeholderText: "AAAA-MM-DD"
      foreground: root.foreground
      font.family: root.fontFamily
      Keys.onReturnPressed: root.save()
      Keys.onEscapePressed: root.cancel()
    }
    TextField {
      id: onField
      width: Style.space(46)
      placeholderText: "2"
      foreground: root.foreground
      font.family: root.fontFamily
      inputMethodHints: Qt.ImhDigitsOnly
      Keys.onReturnPressed: root.save()
      Keys.onEscapePressed: root.cancel()
    }
    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: "/"
      color: root.foreground
    }
    TextField {
      id: offField
      width: Style.space(46)
      placeholderText: "6"
      foreground: root.foreground
      font.family: root.fontFamily
      inputMethodHints: Qt.ImhDigitsOnly
      Keys.onReturnPressed: root.save()
      Keys.onEscapePressed: root.cancel()
    }
    AccentButton {
      text: root.isPortuguese() ? "Salvar" : "Save"
      foreground: root.foreground
      fontFamily: root.fontFamily
      onClicked: root.save()
    }
    SecondaryButton {
      text: "×"
      foreground: root.foreground
      fontFamily: root.fontFamily
      onClicked: root.cancel()
    }
  }

  Text {
    visible: root.errorText !== ""
    width: parent.width
    text: root.errorText
    color: Commons.Color.accent
    font.family: root.fontFamily
    font.pixelSize: Style.font.caption
    horizontalAlignment: Text.AlignHCenter
  }
}
