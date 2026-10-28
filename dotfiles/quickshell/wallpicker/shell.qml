import Quickshell
import Quickshell.Io 
import Quickshell.Wayland 
import Quickshell.Widgets
import QtQuick 
import Qt.labs.folderlistmodel


ShellRoot {
  id: root 
  property bool open: false 
  //Directory for wallpapers
  property string wallDir: Quickshell.env("HOME") + "/nixos-config/dotfiles/hypr/wallpapers"

  //enter property
  Process {
    id: setWallpaper 
    property string path: ""
    command: ["awww", "img", path, 
    "--transition-type", "grow",
    "--transition-pos", "center",
    "--transition-duration", "1.2",
    "--transition-fps", "60"]
  }

  Process {
    id: genColors
    property string path: ""
    command: ["matugen", "image", path, "-m", "dark", "--source-color-index", "0"]
  }

  function apply(path: string): void {
    setWallpaper.path = path
    setWallpaper.running = true 
    genColors.path = path 
    genColors.running = true
    root.open = false
  }

  IpcHandler {
    target: "picker"
    function toggle(): void {root.open = !root.open}
  }

  FolderListModel {
    id: wallpapers
    folder: "file://" + root.wallDir 
    nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
    showDirs: false 
  }

  PanelWindow {
    visible: root.open 
    anchors {left: true; right: true; top: true; bottom: true}
    color: "#660f1c2e"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "wallpicker"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive  

     PathView {
        id: belt
        anchors.centerIn: parent
        width: parent.width
        height: 340
        model: wallpapers
        focus: true

        // How many wallpapers are on screen at once; more = more overlap
        pathItemCount: Math.min(7, wallpapers.count)

        // Lock the selected wallpaper to the middle of the path
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        highlightRangeMode: PathView.StrictlyEnforceRange

        path: Path {
          startX: 0
          startY: belt.height / 2

          // Left edge: smaller, angled, behind, darker
          PathAttribute {name: "itemScale"; value: 0.5}
          PathAttribute {name: "itemAngle"; value: 30}
          PathAttribute {name: "itemZ"; value: 0}
          PathAttribute {name: "itemDim"; value: 0.6}

          PathLine {x: belt.width / 2; y: belt.height / 2}

          // Center: full size, facing you, in front, bright
          PathAttribute {name: "itemScale"; value: 1.0}
          PathAttribute {name: "itemAngle"; value: 0}
          PathAttribute {name: "itemZ"; value: 100}
          PathAttribute {name: "itemDim"; value: 0}

          PathLine {x: belt.width; y: belt.height / 2}

          // Right edge: mirror of the left
          PathAttribute {name: "itemScale"; value: 0.5}
          PathAttribute {name: "itemAngle"; value: -30}
          PathAttribute {name: "itemZ"; value: 0}
          PathAttribute {name: "itemDim"; value: 0.6}
        }

        Keys.onEscapePressed: root.open = false
        Keys.onPressed: (event) => {
          if (event.key === Qt.Key_H) {belt.decrementCurrentIndex(); event.accepted = true}
          else if (event.key === Qt.Key_L) {belt.incrementCurrentIndex(); event.accepted = true}
          else if (event.key === Qt.Key_Return) {root.apply(belt.currentItem.filePath); event.accepted = true}
        }

        delegate: Item {
          id: thumb
          required property string filePath
          width: 480
          height: 300

          z: PathView.itemZ
          scale: PathView.itemScale
          transform: Rotation {
            origin.x: thumb.width / 2
            origin.y: thumb.height / 2
            axis {x: 0; y: 1; z: 0}
            angle: thumb.PathView.itemAngle
          }

          ClippingRectangle {
            anchors.fill: parent
            radius: 16
            color: "#1e3a5f"

            Image {
              anchors.fill: parent
              source: "file://" + thumb.filePath
              sourceSize.width: 600
              fillMode: Image.PreserveAspectCrop
              asynchronous: true
            }

            // Dims more the further a wallpaper is from the center
            Rectangle {
              anchors.fill: parent
              color: "black"
              opacity: thumb.PathView.itemDim
            }
          }

          Rectangle {
            anchors.fill: parent
            radius: 16
            color: "transparent"
            border.width: 3
            border.color: "#6cb6eb"
            visible: thumb.PathView.isCurrentItem
          }
        }
      }
    }
  }

