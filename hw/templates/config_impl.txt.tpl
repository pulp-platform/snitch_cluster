<%def name="icache_cfg(prop)">\
  % for lw in cfg['hives']:
${lw['icache'][prop]}${',' if not loop.last else ''}\
% endfor
</%def>\
${cfg['tcdm']['depth']}x${cfg['data_width']}m4s
%if cfg['hives'][0]['icache']['cacheline'] in (('32','64','128')):
${icache_cfg('depth')}x${icache_cfg('cacheline')}m4s
%else:
${icache_cfg('depth')}x128m4s
%endif
${icache_cfg('depth')}x${cfg['tag_width']}m4s
