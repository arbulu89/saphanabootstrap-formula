{%- from "hana/map.jinja" import hana with context -%}
{% set host = grains['host'] %}

{% if hana.hdbserver_sar_file and hana.sapcar_exe_file is defined %}

extract_hdbserver_sar_{{ host }}:
    sapcar.extracted:
    - name: {{ hana.hdbserver_sar_file }}
    - sapcar_exe: {{ hana.sapcar_exe_file }}
    - output_dir: {{ hana.hdbserver_extract_dir }}
    - options: "-manifest SIGNATURE.SMF"

copy_signature_file_to_installer_dir_{{ host }}:
    file.copy:
    - source: {{ hana.hdbserver_extract_dir }}/SIGNATURE.SMF
    - name: {{ hana.hdbserver_extract_dir }}/SAP_HANA_DATABASE/SIGNATURE.SMF
    - preserve: True
    - force: True
    - require:
        - extract_hdbserver_sar_{{ host }}

{% endif %}