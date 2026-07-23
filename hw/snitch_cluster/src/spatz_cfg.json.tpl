<%!
    import dataclasses
    import json

    def _default(obj):
        if dataclasses.is_dataclass(obj):
            return dataclasses.asdict(obj)
        return vars(obj)
%>\
${json.dumps(
    {'spatz': cfg['cluster']['hives'][0]['cores'][0]['spatz']},
    indent=4,
    default=_default
)}