package {
    import com.rails2u.bridge.ExportJS;

    public function exportJS(obj:Object, name:String = undefined):String {
        return ExportJS.export(obj, name);
    }
}
