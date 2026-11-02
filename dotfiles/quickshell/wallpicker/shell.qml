import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import Qt.labs.folderlistmodel

ShellRoot {
  id: root

  // ---------- State ----------
  property bool open: false
  property string wallDir: Quickshell.env("HOME") + "/nixos-config/dotfiles/hypr/wallpapers"

  // The tint shown behind the belt; starts as a soft dark overlay
  property color tint: "#33000000"
  // Remembers each wallpaper's color so revisiting is instant
  property var tintCache: ({})

  // Look up the current wallpaper's color whenever the picker opens
  onOpenChanged: if (open) previewDelay.restart()

  // ---------- Opening and closing ----------
  IpcHandler {
    target: "picker"
    function toggle(): void { root.open = !root.open }
  }

  // ---------- The wallpapers ----------
  FolderListModel {
    id: wallpapers
    folder: "file://" + root.wallDir
    nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
    showDirs: false
  }

  // ---------- Applying a wallpaper (Enter) ----------
  // Animates the new wallpaper in
  Process {
    id: setWallpaper
    property string path: ""
    command: ["awww", "img", path,
              "--transition-type", "grow",
              "--transition-pos", "center",
              "--transition-duration", "1.2",
              "--transition-fps", "60"]
  }

  // Generates colors from the wallpaper and reloads apps
  Process {
    id: genColors
    property string path: ""
    command: ["matugen", "image", path, "-m", "dark", "--source-color-index", "0"]
  }

    // Keeps ~/.cache/current-wallpaper pointing at the chosen wallpaper
  Process {
    id: saveCurrent
    property string path: ""
    command: ["ln", "-sf", path, Quickshell.env("HOME") + "/.cache/current-wallpaper"]
  }

  function apply(path: string): void {
    setWallpaper.path = path
    setWallpaper.running = true
    genColors.path = path
    genColors.running = true
    root.open = false
    saveCurrent.path = path
    saveCurrent.running = true
  }

  // ---------- Background tint preview (browsing) ----------
  // Asks matugen for a wallpaper's palette without touching any files
  Process {
    id: previewColor
    property string path: ""
    command: ["matugen", "--dry-run", "image", path, "--json", "hex",
              "-m", "dark", "--source-color-index", "0"]
    stdout: StdioCollector {
      onStreamFinished: {
        const hex = root.primaryFromJson(this.text)
        if (hex) {
          root.tintCache[previewColor.path] = hex
          root.tint = "#55" + hex.slice(1, 7)
        }
      }
    }
  }

  // Waits for the selection to settle before asking matugen
  Timer {
    id: previewDelay
    interval: 150
    onTriggered: {
      const path = belt.currentItem ? belt.currentItem.filePath : ""
      if (!path) return
      if (root.tintCache[path]) {
        root.tint = "#55" + root.tintCache[path].slice(1, 7)
        return
      }
      previewColor.running = false
      previewColor.path = path
      previewColor.running = true
    }
  }

  // Pulls the dark-mode primary color out of matugen's JSON
  function primaryFromJson(text: string): string {
    try {
      const c = JSON.parse(text).colors
      if (c.primary && c.primary.dark) return c.primary.dark.color || c.primary.dark
      if (c.dark && c.dark.primary) return c.dark.primary
      if (c.primary && c.primary.default) return c.primary.default.color || c.primary.default
    } catch (e) {}
    console.log("couldn't find primary in matugen output:", text.slice(0, 300))
    return ""
  }

  // ---------- The picker window ----------
  PanelWindow {
    visible: root.open
    anchors { left: true; right: true; top: true; bottom: true }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "wallpicker"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    // Tint behind the belt, fading between wallpaper colors
    Rectangle {
      anchors.fill: parent
      color: root.tint
      Behavior on color { ColorAnimation { duration: 300 } }
    }

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

      // Look up the new wallpaper's color whenever the selection moves
      onCurrentIndexChanged: previewDelay.restart()

      path: Path {
        startX: 0
        startY: belt.height / 2

        // Left edge: smaller, angled, behind, darker
        PathAttribute { name: "itemScale"; value: 0.5 }
        PathAttribute { name: "itemAngle"; value: 30 }
        PathAttribute { name: "itemZ"; value: 0 }
        PathAttribute { name: "itemDim"; value: 0.6 }

        PathLine { x: belt.width / 2; y: belt.height / 2 }

        // Center: full size, facing you, in front, bright
        PathAttribute { name: "itemScale"; value: 1.0 }
        PathAttribute { name: "itemAngle"; value: 0 }
        PathAttribute { name: "itemZ"; value: 100 }
        PathAttribute { name: "itemDim"; value: 0 }

        PathLine { x: belt.width; y: belt.height / 2 }

        // Right edge: mirror of the left
        PathAttribute { name: "itemScale"; value: 0.5 }
        PathAttribute { name: "itemAngle"; value: -30 }
        PathAttribute { name: "itemZ"; value: 0 }
        PathAttribute { name: "itemDim"; value: 0.6 }
      }

      Keys.onEscapePressed: root.open = false
      Keys.onPressed: (event) => {
        if (event.key === Qt.Key_H) { belt.decrementCurrentIndex(); event.accepted = true }
        else if (event.key === Qt.Key_L) { belt.incrementCurrentIndex(); event.accepted = true }
        else if (event.key === Qt.Key_Return) { root.apply(belt.currentItem.filePath); event.accepted = true }
      }

      delegate: Item {
        id: thumb
        required property string filePath
        required property url fileUrl
        width: 480
        height: 300

        z: PathView.itemZ
        scale: PathView.itemScale
        transform: Rotation {
          origin.x: thumb.width / 2
          origin.y: thumb.height / 2
          axis { x: 0; y: 1; z: 0 }
          angle: thumb.PathView.itemAngle
        }

        ClippingRectangle {
          anchors.fill: parent
          radius: 16
          color: "#1e3a5f"

          Image {
            anchors.fill: parent
            source: thumb.fileUrl
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

        // Outline on the selected wallpaper
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
