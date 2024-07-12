import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GdkPixbuf, Gio, GLib

class MyWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="Selector de Fondos de Pantalla")
        self.set_default_size(600, 400)

        # Barra de título personalizada
        titlebar = Gtk.HeaderBar()
        titlebar.set_title("Selector de Fondos de Pantalla")
        titlebar.set_show_close_button(True)
        self.set_titlebar(titlebar)

        # Caja vertical para contener widgets
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.add(vbox)

        # Selector de carpeta
        folder_button = Gtk.Button(label="Seleccionar carpeta de imágenes")
        folder_button.connect("clicked", self.on_folder_button_clicked)
        vbox.pack_start(folder_button, False, False, 0)

        # Vista de miniaturas
        self.iconview = Gtk.IconView()
        self.iconview.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self.iconview.set_columns(5)
        self.iconview.set_item_width(100)
        self.iconview.connect("item-activated", self.on_icon_activated)
        vbox.pack_start(self.iconview, True, True, 0)

    def on_folder_button_clicked(self, widget):
        dialog = Gtk.FileChooserDialog(
            "Seleccione una carpeta de imágenes",
            self,
            Gtk.FileChooserAction.SELECT_FOLDER,
            (Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL, "Seleccionar", Gtk.ResponseType.OK)
        )

        response = dialog.run()
        if response == Gtk.ResponseType.OK:
            folder = dialog.get_filename()
            self.load_images(folder)
        dialog.destroy()

    def load_images(self, folder):
        self.iconview.clear()
        pixbufs = []
        for file_info in Gio.File.new_for_path(folder).enumerate_children('*', Gio.FileQueryInfoFlags.NONE, None):
            file_path = file_info.get_path()
            if file_info.get_file_type() == Gio.FileType.REGULAR:
                try:
                    pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(file_path, 100, 100)
                    pixbufs.append(pixbuf)
                except GLib.Error as e:
                    print(f"Error al cargar la imagen {file_path}: {e.message}")
        self.iconview.set_model(Gtk.ListStore(GdkPixbuf.Pixbuf))
        self.iconview.set_pixbuf_column(0)
        for pixbuf in pixbufs:
            self.iconview.add_item(pixbuf)

    def on_icon_activated(self, iconview, path):
        model = iconview.get_model()
        iter = model.get_iter(path)
        pixbuf = model.get_value(iter, 0)
        selected_file = pixbuf.get_option("file")
        self.set_wallpaper(selected_file)

    def set_wallpaper(self, file_path):
        # Aquí podrías agregar la lógica para establecer el fondo de pantalla con swaybg
        print("Fondo de pantalla establecido:", file_path)

# Crear y mostrar la ventana
win = MyWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()
