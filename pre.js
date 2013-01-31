((typeof exports !== "undefined" && exports !== null) ? exports : this)["Viz"] = function(src, format, layoutEngine) {
  var Module = {};
  if (format === undefined)
  	format = "svg";
  if (layoutEngine === undefined)
	  layoutEngine = "dot";
  Module["return"] = "";
  Module["print"] = function(text) {
    Module["return"] += text + "\n";
  }
