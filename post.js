  Module["ccall"]("vizRenderFromString", "number", ["string", "string", "string"], [src, format, layoutEngine]);
  return Module["return"];
}

if (this.document === undefined) {
	// Web Worker mode
	
	// Incoming message = { payload : { source, format }, workerHandle }
	// Outgoing message = { payload : "", workerHandle }

	// workerHandle is a random Number (assigned by the host) to match 
	// request and response.

	this.onmessage = function (event) {
		var payload = event["data"]["payload"];
		var result;
		try {
			result = { "payload" : Viz(payload["source"], payload["format"], payload["layoutEngine"]) };
		} catch (error) {
			result = { "error" : error.stack };
		}
		result["workerHandle"] = event["data"]["workerHandle"];
		this.postMessage(result);
	}
} else {
	// regular browser mode
	window["Viz"] = Viz;
}

