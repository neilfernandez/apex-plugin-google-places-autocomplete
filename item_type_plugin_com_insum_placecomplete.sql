set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.1.00.08'
,p_default_workspace_id=>1880665973001338
,p_default_application_id=>254
,p_default_owner=>'SANDBOX'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/com_insum_placecomplete
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(137888084662405544)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM.INSUM.PLACECOMPLETE'
,p_display_name=>'Google Places Autocomplete'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'procedure render_autocomplete  (',
'    p_item in apex_plugin.t_item,',
'    p_plugin in apex_plugin.t_plugin,',
'    p_param in apex_plugin.t_item_render_param,',
'    p_result in out nocopy apex_plugin.t_item_render_result ) IS',
'',
'    subtype plugin_attr is varchar2(32767);',
'',
'    l_result apex_plugin.t_item_render_result;',
'    l_js_params varchar2(1000);',
'    l_onload_string varchar2(32767);',
'',
'    -- Plugin attributes',
'    l_api_key plugin_attr := p_plugin.attribute_01;',
'',
'    -- Component attributes',
'    l_action plugin_attr := p_item.attribute_01;',
'    l_address plugin_attr := p_item.attribute_02;',
'    l_city plugin_attr := p_item.attribute_03;',
'    l_state plugin_attr := p_item.attribute_04;',
'    l_zip plugin_attr := p_item.attribute_05;',
'    l_country plugin_attr := p_item.attribute_06;',
'    l_latitude plugin_attr := p_item.attribute_07;',
'    l_longitude plugin_attr := p_item.attribute_08;',
'    l_address_long plugin_attr := p_item.attribute_09;',
'    l_state_long plugin_attr := p_item.attribute_10;',
'    l_country_long plugin_attr := p_item.attribute_11;',
'    l_location_type plugin_attr := p_item.attribute_12;',
'',
'    -- Component type',
'    l_component_type plugin_attr := p_item.component_type_id;',
'',
'begin',
'',
'    -- Get API key for JS file name',
'    l_js_params := ''?key='' || l_api_key || ''&libraries=places'';',
'',
'    apex_javascript.add_library',
'          (p_name           => ''js'' || l_js_params',
'          ,p_directory      => ''https://maps.googleapis.com/maps/api/''',
'          ,p_skip_extension => true);',
'',
'    apex_javascript.add_library',
'      (p_name                  => ''jquery.ui.autoComplete''',
'      ,p_directory             => p_plugin.file_prefix);',
'',
'    -- For use with APEX 5.1 and up. Print input element.',
'    sys.htp.prn (apex_string.format(''<input type="text" %s size="%s" maxlength="%s"/>''',
'                                    , apex_plugin_util.get_element_attributes(p_item, p_item.name, ''text_field'')',
'                                    , p_item.element_width',
'                                    , p_item.element_max_length));',
'',
'l_onload_string :=',
'''',
'$("#%NAME%").placesAutocomplete({',
'  pageItems : {',
'    autoComplete : {',
'      %AUTOCOMPLETE_ID%',
'    },',
'    lat : {',
'      %LAT_ID%',
'    },',
'    lng : {',
'      %LNG_ID%',
'    },',
'    route : {',
'      %ROUTE_ID%',
'      %ROUTE_FORM%',
'    },',
'    locality : {',
'      %LOCALITY_ID%',
'      %LOCALITY_FORM%',
'    },',
'    administrative_area_level_1 : {',
'      %ADMINISTRATIVE_AREA_LEVEL_1_ID%',
'      %ADMINISTRATIVE_AREA_LEVEL_1_FORM%',
'    },',
'    postal_code : {',
'      %POSTAL_CODE_ID%',
'      %POSTAL_CODE_FORM%',
'    },',
'    country : {',
'      %COUNTRY_ID%',
'      %COUNTRY_FORM%',
'    }',
'  },',
'  %ACTION%',
'  %TYPE%',
'  %COMPONENT_TYPE%',
'});',
''';',
'    l_onload_string := replace(l_onload_string,''%NAME%'',p_item.name);',
'    l_onload_string := replace(l_onload_string, ''%AUTOCOMPLETE_ID%'', apex_javascript.add_attribute(''id'',  p_item.name));',
'    l_onload_string := replace(l_onload_string, ''%ROUTE_ID%'', apex_javascript.add_attribute(''id'',  l_address));',
'    l_onload_string := replace(l_onload_string, ''%ROUTE_FORM%'', apex_javascript.add_attribute(''form'',  CASE WHEN l_address_long = ''Y'' THEN ''long_name'' ELSE ''short_name'' END));',
'    l_onload_string := replace(l_onload_string, ''%LOCALITY_ID%'', apex_javascript.add_attribute(''id'',  l_city));',
'    l_onload_string := replace(l_onload_string, ''%LOCALITY_FORM%'', apex_javascript.add_attribute(''form'',  ''long_name''));',
'    l_onload_string := replace(l_onload_string, ''%ADMINISTRATIVE_AREA_LEVEL_1_ID%'', apex_javascript.add_attribute(''id'',  l_state));',
'    l_onload_string := replace(l_onload_string, ''%ADMINISTRATIVE_AREA_LEVEL_1_FORM%'', apex_javascript.add_attribute(''form'',  CASE WHEN l_state_long = ''Y'' THEN ''long_name'' ELSE ''short_name'' END));',
'    l_onload_string := replace(l_onload_string, ''%POSTAL_CODE_ID%'', apex_javascript.add_attribute(''id'',  l_zip));',
'    l_onload_string := replace(l_onload_string, ''%POSTAL_CODE_FORM%'', apex_javascript.add_attribute(''form'',  ''long_name''));',
'    l_onload_string := replace(l_onload_string, ''%COUNTRY_ID%'', apex_javascript.add_attribute(''id'',  l_country));',
'    l_onload_string := replace(l_onload_string, ''%COUNTRY_FORM%'', apex_javascript.add_attribute(''form'',  CASE WHEN l_country_long = ''Y'' THEN ''long_name'' ELSE ''short_name'' END));',
'    l_onload_string := replace(l_onload_string, ''%LAT_ID%'', apex_javascript.add_attribute(''id'',  l_latitude));',
'    l_onload_string := replace(l_onload_string, ''%LNG_ID%'', apex_javascript.add_attribute(''id'',  l_longitude));',
'    l_onload_string := replace(l_onload_string, ''%ACTION%'', apex_javascript.add_attribute(''action'',  l_action));',
'    l_onload_string := replace(l_onload_string, ''%TYPE%'', apex_javascript.add_attribute(''locationType'',  l_location_type));',
'    l_onload_string := replace(l_onload_string, ''%COMPONENT_TYPE%'', apex_javascript.add_attribute(''componentType'',  l_component_type));',
'',
'    apex_javascript.add_inline_code(p_code => l_onload_string);',
'',
'    p_result.is_navigable := true;',
'',
'end render_autocomplete;'))
,p_api_version=>2
,p_render_function=>'render_autocomplete'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:SOURCE:ELEMENT:WIDTH:ENCRYPT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>4
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137888905158417223)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Google Maps API Key'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_help_text=>'Enter your Google Maps API key here. You can get one from : https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete-addressform'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137890457692422129)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Action'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'If left null, you may only select a Google Place Address.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137890924681424105)
,p_plugin_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_display_sequence=>10
,p_display_value=>'Split into items and return JSON'
,p_return_value=>'SPLIT'
,p_help_text=>'Will split the address returned to be stored into multiple page items such as Street, City, State, Zip, etc.. As well as return the JSON if needed. The JSON data can be retrieved with the place_changed custom dynamic action event.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137891322528427830)
,p_plugin_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_display_sequence=>20
,p_display_value=>'Only return JSON'
,p_return_value=>'JSON'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Will just return the JSON contatining all the address components from the Google Place Address chosen.',
'The data can be retrieved with the place_changed custom dynamic action event.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137894468600497599)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Address Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the street address into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137896047363500462)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'City Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the city into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137897261437505124)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'State Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the state into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137898926052507700)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Zip Code Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the zip code into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137901312828513354)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Country Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the country into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137903917196518168)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Latitude Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the latitude into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137905335583520803)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Longitude Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the longitude into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137906949839525361)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Address Long Form'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137894468600497599)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Long form : 123 Testing Street',
'<br>',
'Short form: 123 Testing St.'))
,p_help_text=>'If set to ''Yes'', then the street address returned will be in long form. If set to ''No'', the street address returned will be in short form.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137908475842528777)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'State Long Form'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137897261437505124)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Long form : New York',
'<br>',
'Short form: NY'))
,p_help_text=>'If set to ''Yes'', then the state returned will be in long form. If set to ''No'', the state returned will be in short form.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137909660455532236)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Country Long Form'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137901312828513354)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Long form : United States',
'<br>',
'Short form: US'))
,p_help_text=>'If set to ''Yes'', then the country returned will be in long form. If set to ''No'', the country returned will be in short form.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137910899809534566)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Place Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_null_text=>'All'
,p_help_text=>'You may restrict results from a Place Autocomplete request to be of a certain type by passing a types parameter. The parameter specifies a type or a type collection, as listed in the supported types below. If nothing is specified, all types are retur'
||'ned. In general only a single type is allowed. The exception is that you can safely mix the geocode and establishment types, but note that this will have the same effect as specifying no types.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137912157318535930)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>10
,p_display_value=>'geocode'
,p_return_value=>'geocode'
,p_help_text=>'geocode instructs the Place Autocomplete service to return only geocoding results, rather than business results. Generally, you use this request to disambiguate results where the location specified may be indeterminate.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137912580503536970)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>20
,p_display_value=>'address'
,p_return_value=>'address'
,p_help_text=>'address instructs the Place Autocomplete service to return only geocoding results with a precise address. Generally, you use this request when you know the user will be looking for a fully specified address.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137912960990538173)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>30
,p_display_value=>'establishment'
,p_return_value=>'establishment'
,p_help_text=>'establishment instructs the Place Autocomplete service to return only business results.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137930424860539427)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>40
,p_display_value=>'(regions)'
,p_return_value=>'(regions)'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The (regions) type collection instructs the Places service to return any result matching the following types:',
'locality',
'sublocality',
'postal_code',
'country',
'administrative_area_level_1',
'administrative_area_level_2'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137930902879541207)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>50
,p_display_value=>'(cities)'
,p_return_value=>'(cities)'
,p_help_text=>'The (cities) type collection instructs the Places service to return results that match locality or administrative_area_level_3.'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0D0A202A20496E73756D20536F6C7574696F6E7320476F6F676C6520506C616365732041646472657373204175746F636F6D706C65746520666F7220415045580D0A202A20506C75672D696E20547970653A204974656D0D0A202A2053756D6D61';
wwv_flow_api.g_varchar2_table(2) := '72793A20506C7567696E20746F206175746F636F6D706C6574652061206C6F636174696F6E20616E642072657475726E20746865206164647265737320696E746F207365706172617465206669656C64732C2061732077656C6C2061732072657475726E';
wwv_flow_api.g_varchar2_table(3) := '2061646472657373204A534F4E20646174610D0A202A0D0A202A0D0A202A2056657273696F6E3A0D0A202A2020312E302E303A20496E697469616C0D0A202A0D0A202A205E5E5E20436F6E7461637420696E666F726D6174696F6E205E5E5E0D0A202A20';
wwv_flow_api.g_varchar2_table(4) := '446576656C6F70656420627920496E73756D20536F6C7574696F6E730D0A202A20687474703A2F2F7777772E696E73756D2E63610D0A202A206E6665726E30303240706C6174747362757267682E6564750D0A202A0D0A202A205E5E5E204C6963656E73';
wwv_flow_api.g_varchar2_table(5) := '65205E5E5E0D0A202A204C6963656E73656420556E6465723A20546865204D4954204C6963656E736520284D495429202D20687474703A2F2F7777772E6F70656E736F757263652E6F72672F6C6963656E7365732F67706C2D332E302E68746D6C0D0A20';
wwv_flow_api.g_varchar2_table(6) := '2A0D0A202A2040617574686F72204E65696C204665726E616E64657A202D20687474703A2F2F7777772E6E65696C6665726E616E64657A2E636F6D0D0A202A2F0D0A0D0A242E776964676574282775692E706C616365734175746F636F6D706C65746527';
wwv_flow_api.g_varchar2_table(7) := '2C207B0D0A20202F2F2044656661756C74206F7074696F6E730D0A20206F7074696F6E733A207B0D0A20202020706167654974656D733A207B0D0A2020202020206175746F436F6D706C6574653A207B0D0A202020202020202069643A2027270D0A2020';
wwv_flow_api.g_varchar2_table(8) := '202020207D2C0D0A202020202020726F7574653A207B0D0A202020202020202069643A2027270D0A2020202020207D2C0D0A2020202020206C6F63616C6974793A207B0D0A202020202020202069643A2027270D0A2020202020207D2C0D0A2020202020';
wwv_flow_api.g_varchar2_table(9) := '2061646D696E6973747261746976655F617265615F6C6576656C5F313A207B0D0A202020202020202069643A2027270D0A2020202020207D2C0D0A202020202020706F7374616C5F636F64653A207B0D0A202020202020202069643A2027270D0A202020';
wwv_flow_api.g_varchar2_table(10) := '2020207D2C0D0A202020202020636F756E7472793A207B0D0A202020202020202069643A2027270D0A2020202020207D0D0A202020207D2C0D0A20202020616464726573735F636F6D706F6E656E74733A207B0D0A202020202020726F7574653A207B0D';
wwv_flow_api.g_varchar2_table(11) := '0A202020202020202069643A2027272C0D0A2020202020202020666F726D3A2027270D0A2020202020207D2C0D0A2020202020206C6F63616C6974793A207B0D0A202020202020202069643A2027272C0D0A2020202020202020666F726D3A2027270D0A';
wwv_flow_api.g_varchar2_table(12) := '2020202020207D2C0D0A20202020202061646D696E6973747261746976655F617265615F6C6576656C5F313A207B0D0A202020202020202069643A2027272C0D0A2020202020202020666F726D3A2027270D0A2020202020207D2C0D0A20202020202070';
wwv_flow_api.g_varchar2_table(13) := '6F7374616C5F636F64653A207B0D0A202020202020202069643A2027272C0D0A2020202020202020666F726D3A2027270D0A2020202020207D2C0D0A202020202020636F756E7472793A207B0D0A202020202020202069643A2027272C0D0A2020202020';
wwv_flow_api.g_varchar2_table(14) := '202020666F726D3A2027270D0A2020202020207D0D0A202020207D0D0A20207D2C0D0A0D0A0D0A20202F2A2A0D0A2020202A205365742070726976617465207769646765742076617261626C65732E0D0A2020202A2F0D0A20205F736574576964676574';
wwv_flow_api.g_varchar2_table(15) := '566172733A2066756E6374696F6E2829207B0D0A2020202076617220756977203D20746869733B0D0A0D0A202020207569772E5F73636F7065203D202775692E706C616365734175746F636F6D706C657465273B202F2F466F7220646562756767696E67';
wwv_flow_api.g_varchar2_table(16) := '0D0A0D0A202020207569772E5F76616C756573203D207B0D0A202020202020706C6163655F6A736F6E3A207B7D0D0A202020207D3B0D0A0D0A202020207569772E5F656C656D656E7473203D207B0D0A20202020202024656C656D656E743A2024287569';
wwv_flow_api.g_varchar2_table(17) := '772E656C656D656E74290D0A202020207D3B0D0A20207D2C202F2F5F736574576964676574566172730D0A0D0A20202F2A2A0D0A2020202A204372656174652066756E6374696F6E3A204F6E6C792063616C6C6564207468652066697273742074696D65';
wwv_flow_api.g_varchar2_table(18) := '207468652077696467657420697320617373696F636174656420746F20746865206F626A6563740D0A2020202A2057696C6C20696D706C696369746C792063616C6C20746865205F696E69742066756E6374696F6E2061667465720D0A2020202A2F0D0A';
wwv_flow_api.g_varchar2_table(19) := '20205F6372656174653A2066756E6374696F6E2829207B0D0A2020202076617220756977203D20746869733B0D0A0D0A202020207569772E5F7365745769646765745661727328293B202F2F20536574207661726961626C65732028646F6E2774206D6F';
wwv_flow_api.g_varchar2_table(20) := '646966792074686973290D0A0D0A2020202076617220636F6E736F6C6547726F75704E616D65203D207569772E5F73636F7065202B20275F637265617465273B0D0A20202020636F6E736F6C652E67726F7570436F6C6C617073656428636F6E736F6C65';
wwv_flow_api.g_varchar2_table(21) := '47726F75704E616D65293B0D0A20202020636F6E736F6C652E6C6F672827746869733A272C20756977293B0D0A0D0A202020202F2F5265676973746572206175746F436F6D706C6574650D0A20202020766172206175746F636F6D706C657465203D206E';
wwv_flow_api.g_varchar2_table(22) := '657720676F6F676C652E6D6170732E706C616365732E4175746F636F6D706C657465280D0A2020202020202F2A2A204074797065207B2148544D4C496E707574456C656D656E747D202A2F0D0A20202020202028646F63756D656E742E676574456C656D';
wwv_flow_api.g_varchar2_table(23) := '656E7442794964287569772E6F7074696F6E732E706167654974656D732E6175746F436F6D706C6574652E696429292C207B0D0A202020202020202074797065733A205B5D0D0A2020202020207D293B0D0A0D0A202020202F2F20426961732074686520';
wwv_flow_api.g_varchar2_table(24) := '6175746F636F6D706C657465206F626A65637420746F20746865207573657227732067656F67726170686963616C206C6F636174696F6E2C0D0A202020202F2F20617320737570706C696564206279207468652062726F77736572277320276E61766967';
wwv_flow_api.g_varchar2_table(25) := '61746F722E67656F6C6F636174696F6E27206F626A6563742E0D0A20202020696620286E6176696761746F722E67656F6C6F636174696F6E29207B0D0A2020202020206E6176696761746F722E67656F6C6F636174696F6E2E67657443757272656E7450';
wwv_flow_api.g_varchar2_table(26) := '6F736974696F6E2866756E6374696F6E28706F736974696F6E29207B0D0A20202020202020207661722067656F6C6F636174696F6E203D207B0D0A202020202020202020206C61743A20706F736974696F6E2E636F6F7264732E6C617469747564652C0D';
wwv_flow_api.g_varchar2_table(27) := '0A202020202020202020206C6E673A20706F736974696F6E2E636F6F7264732E6C6F6E6769747564650D0A20202020202020207D3B0D0A202020202020202076617220636972636C65203D206E657720676F6F676C652E6D6170732E436972636C65287B';
wwv_flow_api.g_varchar2_table(28) := '0D0A2020202020202020202063656E7465723A2067656F6C6F636174696F6E2C0D0A202020202020202020207261646975733A20706F736974696F6E2E636F6F7264732E61636375726163790D0A20202020202020207D293B0D0A202020202020202061';
wwv_flow_api.g_varchar2_table(29) := '75746F636F6D706C6574652E736574426F756E647328636972636C652E676574426F756E64732829293B0D0A2020202020207D293B0D0A202020207D0D0A0D0A202020202F2F205768656E2074686520757365722073656C6563747320616E2061646472';
wwv_flow_api.g_varchar2_table(30) := '6573732066726F6D207468652064726F70646F776E2C20706F70756C6174652074686520616464726573730D0A202020202F2F206669656C647320696E2074686520666F726D2E0D0A0D0A202020206175746F636F6D706C6574652E6164644C69737465';
wwv_flow_api.g_varchar2_table(31) := '6E65722827706C6163655F6368616E676564272C2066756E6374696F6E2829207B0D0A0D0A2020202020202F2F5573696E6720696E7465726E616C2076616C75657320616E642066756E6374696F6E732E0D0A2020202020207569772E5F656C656D656E';
wwv_flow_api.g_varchar2_table(32) := '74732E706C616365203D206175746F636F6D706C6574652E676574506C61636528293B0D0A2020202020207569772E5F67656E65726174654A534F4E28293B0D0A0D0A2020202020202F2F205472696767657220706C6163655F6368616E67656420696E';
wwv_flow_api.g_varchar2_table(33) := '20415045580D0A2020202020202F2F204D61792070757420696E746F205F67656E65726174654A534F4E0D0A202020202020617065782E6A517565727928222322202B207569772E6F7074696F6E732E706167654974656D732E6175746F436F6D706C65';
wwv_flow_api.g_varchar2_table(34) := '74652E6964292E747269676765722822706C6163655F6368616E676564222C207569772E5F76616C7565732E706C6163655F6A736F6E293B0D0A0D0A202020202020696620287569772E6F7074696F6E732E616374696F6E203D3D202253504C49542229';
wwv_flow_api.g_varchar2_table(35) := '207B0D0A0D0A20202020202020202F2F20436C656172206F757420616C6C206974656D732065786365707420666F72207468652061646472657373206669656C640D0A2020202020202020666F722028766172206974656D20696E207569772E6F707469';
wwv_flow_api.g_varchar2_table(36) := '6F6E732E706167654974656D7329207B0D0A202020202020202020206974656D203D3D20276175746F436F6D706C65746527203F206E756C6C203A202473287569772E6F7074696F6E732E706167654974656D735B6974656D5D2E69642C202727293B0D';
wwv_flow_api.g_varchar2_table(37) := '0A20202020202020207D0D0A0D0A20202020202020202F2F536574206C6174697475646520616E64206C6F6E67697475646520696620746865792065786973740D0A20202020202020207569772E6F7074696F6E732E706167654974656D735B276C6174';
wwv_flow_api.g_varchar2_table(38) := '275D2E6964203F202473287569772E6F7074696F6E732E706167654974656D735B276C6174275D2E69642C207569772E5F656C656D656E74732E706C6163652E67656F6D657472792E6C6F636174696F6E2E6C6174282929203A206E756C6C3B0D0A2020';
wwv_flow_api.g_varchar2_table(39) := '2020202020207569772E6F7074696F6E732E706167654974656D735B276C6E67275D2E6964203F202473287569772E6F7074696F6E732E706167654974656D735B276C6E67275D2E69642C207569772E5F656C656D656E74732E706C6163652E67656F6D';
wwv_flow_api.g_varchar2_table(40) := '657472792E6C6F636174696F6E2E6C6E67282929203A206E756C6C3B0D0A0D0A2020202020202020666F7220287661722069203D20303B2069203C207569772E5F656C656D656E74732E706C6163652E616464726573735F636F6D706F6E656E74732E6C';
wwv_flow_api.g_varchar2_table(41) := '656E6774683B20692B2B29207B0D0A20202020202020202020766172206164647265737354797065203D207569772E5F656C656D656E74732E706C6163652E616464726573735F636F6D706F6E656E74735B695D2E74797065735B305D3B0D0A20202020';
wwv_flow_api.g_varchar2_table(42) := '202020202020696620287569772E6F7074696F6E732E616464726573735F636F6D706F6E656E74735B61646472657373547970655D29207B0D0A202020202020202020202020696620287569772E6F7074696F6E732E616464726573735F636F6D706F6E';
wwv_flow_api.g_varchar2_table(43) := '656E74735B61646472657373547970655D5B276964275D29207B0D0A2020202020202020202020202020696620286164647265737354797065203D3D2027726F7574652729207B0D0A202020202020202020202020202020207661722076616C203D2075';
wwv_flow_api.g_varchar2_table(44) := '69772E5F656C656D656E74732E706C6163652E616464726573735F636F6D706F6E656E74735B305D2E73686F72745F6E616D65202B20272027202B207569772E5F656C656D656E74732E706C6163652E616464726573735F636F6D706F6E656E74735B69';
wwv_flow_api.g_varchar2_table(45) := '5D5B7569772E6F7074696F6E732E616464726573735F636F6D706F6E656E74735B61646472657373547970655D5B27666F726D275D5D3B0D0A20202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020766172';
wwv_flow_api.g_varchar2_table(46) := '2076616C203D207569772E5F656C656D656E74732E706C6163652E616464726573735F636F6D706F6E656E74735B695D5B7569772E6F7074696F6E732E616464726573735F636F6D706F6E656E74735B61646472657373547970655D5B27666F726D275D';
wwv_flow_api.g_varchar2_table(47) := '5D3B0D0A20202020202020202020202020207D0D0A20202020202020202020202020202473287569772E6F7074696F6E732E616464726573735F636F6D706F6E656E74735B61646472657373547970655D5B276964275D2C2076616C293B0D0A20202020';
wwv_flow_api.g_varchar2_table(48) := '20202020202020207D0D0A202020202020202020207D0D0A20202020202020207D0D0A2020202020207D0D0A202020207D293B0D0A0D0A20202020636F6E736F6C652E67726F7570456E6428636F6E736F6C6547726F75704E616D65293B0D0A20207D2C';
wwv_flow_api.g_varchar2_table(49) := '202F2F5F6372656174650D0A0D0A20202F2A2A0D0A2020202A20496E69742066756E6374696F6E2E20546869732066756E6374696F6E2077696C6C2062652063616C6C656420656163682074696D65207468652077696467657420697320726566657265';
wwv_flow_api.g_varchar2_table(50) := '6E6365642077697468206E6F20706172616D65746572730D0A2020202A2F0D0A20205F696E69743A2066756E6374696F6E28706C61636529207B0D0A2020202076617220756977203D20746869733B0D0A202020202F2F2020636F6E736F6C6547726F75';
wwv_flow_api.g_varchar2_table(51) := '704E616D65203D207569772E5F73636F7065202B20275F696E6974273B0D0A20202020636F6E736F6C652E6C6F67287569772E5F73636F70652C20275F696E6974272C20756977293B0D0A20207D2C202F2F5F696E69740D0A0D0A20202F2A2A0D0A2020';
wwv_flow_api.g_varchar2_table(52) := '202A20536176657320706C6163655F6A736F6E20696E746F20696E7465726E616C205F76616C7565730D0A2020202A2F0D0A20205F67656E65726174654A534F4E3A2066756E6374696F6E2829207B0D0A2020202076617220756977203D20746869733B';
wwv_flow_api.g_varchar2_table(53) := '0D0A2020202076617220706C616365203D207569772E5F656C656D656E74732E706C6163653B0D0A0D0A202020207569772E5F76616C7565732E706C6163655F6A736F6E5B226C6174225D203D20706C6163652E67656F6D657472792E6C6F636174696F';
wwv_flow_api.g_varchar2_table(54) := '6E2E6C617428293B0D0A202020207569772E5F76616C7565732E706C6163655F6A736F6E5B226C6E67225D203D20706C6163652E67656F6D657472792E6C6F636174696F6E2E6C6E6728293B0D0A0D0A20202020666F7220287661722069203D20303B20';
wwv_flow_api.g_varchar2_table(55) := '69203C20706C6163652E616464726573735F636F6D706F6E656E74732E6C656E6774683B20692B2B29207B0D0A202020202020766172206164647265737354797065203D20706C6163652E616464726573735F636F6D706F6E656E74735B695D2E747970';
wwv_flow_api.g_varchar2_table(56) := '65735B305D3B0D0A2020202020207569772E5F76616C7565732E706C6163655F6A736F6E5B61646472657373547970655D203D20706C6163652E616464726573735F636F6D706F6E656E74735B695D2E6C6F6E675F6E616D653B0D0A202020207D0D0A0D';
wwv_flow_api.g_varchar2_table(57) := '0A20202020636F6E736F6C652E6C6F67287569772E5F73636F70652C20275F67656E65726174654A534F4E272C20756977293B0D0A0D0A20207D2C202F2F5F67656E65726174654A534F4E0D0A0D0A202064657374726F793A2066756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(58) := '207B0D0A2020202076617220756977203D20746869733B0D0A20202020242E636F6E736F6C652E6C6F67287569772E5F73636F70652C202764657374726F79272C20756977293B0D0A0D0A20202020242E5769646765742E70726F746F747970652E6465';
wwv_flow_api.g_varchar2_table(59) := '7374726F792E6170706C79287569772C20617267756D656E7473293B202F2F2064656661756C742064657374726F790D0A20207D202F2F64657374726F790D0A0D0A7D293B202F2F75692E7769646765744E616D650D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(143399987013952216)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_file_name=>'jquery.ui.autoComplete.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
