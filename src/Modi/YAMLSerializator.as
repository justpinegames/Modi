package Modi
{
    import org.as3yaml.YAML;

    public class YAMLSerializator extends CommonSerializator
    {
        override public function serializeData():*
        {
            var finalValue:* = this.stackTop();

            var yamlData:String = YAML.encode(finalValue);
            return yamlData;
        }
    }
}