set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,23586211258544398));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,300);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/org_blogsite_jaris_google_plus_one_button
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 40739742893104145 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'ORG.BLOGSITE.JARIS.GOOGLE_PLUS_ONE_BUTTON'
 ,p_display_name => 'Google +1 Button'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'function render_google_plus_one_button ('||unistr('\000a')||
'	p_item					in apex_plugin.t_page_item,'||unistr('\000a')||
'	p_plugin				in apex_plugin.t_plugin,'||unistr('\000a')||
'	p_value					in varchar2,'||unistr('\000a')||
'	p_is_readonly			in boolean,'||unistr('\000a')||
'	p_is_printer_friendly	in boolean'||unistr('\000a')||
') return apex_plugin.t_page_item_render_result'||unistr('\000a')||
'as'||unistr('\000a')||
'	c_host constant varchar2(4000) := apex_util.host_url(''SCRIPT'');'||unistr('\000a')||
''||unistr('\000a')||
'	l_url			varchar2(4000);'||unistr('\000a')||
'	l_page_url		varchar2(4000)	:= p_item.attribute_02;'||
''||unistr('\000a')||
'	l_custom_url	varchar2(4000)	:= p_item.attribute_03;'||unistr('\000a')||
'	l_url_to_plus	varchar2(20)	:= coalesce(p_item.attribute_01, ''current_page'');'||unistr('\000a')||
'	l_size			varchar2(20)	:= coalesce(p_item.attribute_04, ''standard'');'||unistr('\000a')||
'	l_annotation	varchar2(20)	:= coalesce(p_item.attribute_05, ''bubble'');'||unistr('\000a')||
'	l_width			varchar2(256)	:= p_item.attribute_06;'||unistr('\000a')||
'	l_align			varchar2(20)	:= coalesce(p_item.attribute_07, ''left'');'||unistr('\000a')||
'	l_expandto		'||
'varchar2(100)	:= p_item.attribute_08;'||unistr('\000a')||
'	l_result		apex_plugin.t_page_item_render_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
'	-- Don''t show the widget if we are running in printer friendly mode'||unistr('\000a')||
'	if p_is_printer_friendly then'||unistr('\000a')||
'		return null;'||unistr('\000a')||
'	end if;'||unistr('\000a')||
''||unistr('\000a')||
'	-- Generate the Google +1 URL based on our URL setting.'||unistr('\000a')||
'	-- Note: Always use session 0, otherwise Google +1 will always register a different URL.'||unistr('\000a')||
'	l_url := case l_url_to_plus'||unistr('\000a')||
'				w'||
'hen ''current_page'' then'||unistr('\000a')||
'					c_host || ''f?p='' || apex_application.g_flow_id || '':'' || apex_application.g_flow_step_id || '':0'''||unistr('\000a')||
'				when ''page_url'' then'||unistr('\000a')||
'					c_host||l_page_url'||unistr('\000a')||
'				when ''custom_url'' then'||unistr('\000a')||
'					replace(l_custom_url, ''#HOST#'', c_host)'||unistr('\000a')||
'				when ''value'' then'||unistr('\000a')||
'					replace(p_value, ''#HOST#'', c_host)'||unistr('\000a')||
'				end;'||unistr('\000a')||
'	-- Output the Google +1 button widget'||unistr('\000a')||
'	-- See https://developers.google.com/+/web'||
'/+1button/ for syntax'||unistr('\000a')||
'	sys.htp.prn ('||unistr('\000a')||
'			''<div class="g-plusone"'''||unistr('\000a')||
'		||	'' data-href="'' || apex_escape.html_attribute(l_url) || ''"'''||unistr('\000a')||
'		||	'' data-size="'' || apex_escape.html_attribute(l_size) || ''"'''||unistr('\000a')||
'		||	'' data-annotation="'' || apex_escape.html_attribute(l_annotation) || ''"'''||unistr('\000a')||
'		||	case when l_annotation = ''inline'' then'||unistr('\000a')||
'				'' data-width="'' || apex_escape.html_attribute(l_annotation) || ''"'''||unistr('\000a')||
'			end'||unistr('\000a')||
'		||	'' '||
'data-align="'' || apex_escape.html_attribute(l_align) || ''"'''||unistr('\000a')||
'		||	'' data-expandTo="'' || apex_escape.html_attribute(replace(l_expandto, '':'', '','')) || ''"'''||unistr('\000a')||
'		||	''></div>'''||unistr('\000a')||
'	);'||unistr('\000a')||
'	apex_javascript.add_library('||unistr('\000a')||
'		p_name		=> ''platform'','||unistr('\000a')||
'		p_directory	=> ''https://apis.google.com/js/'','||unistr('\000a')||
'		p_key		=> ''com.google.apis.platform'''||unistr('\000a')||
'	);'||unistr('\000a')||
'	-- Tell APEX that this field is NOT navigable'||unistr('\000a')||
'	l_result.is_navigable := false;'||unistr('\000a')||
'	re'||
'turn l_result;'||unistr('\000a')||
'end render_google_plus_one_button;'
 ,p_render_function => 'render_google_plus_one_button'
 ,p_standard_attributes => 'VISIBLE:SOURCE:ELEMENT'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_help_text => '<p>'||unistr('\000a')||
'	Google +1 button widget based on the definition at <a href="https://developers.google.com/+/web/+1button/" target="_blank">https://developers.google.com/+/web/+1button/</a></p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	Let visitors recommend your content on Google Search and share it on Google+.</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	Use of the Google +1 Button code is subject to the <a href="https://developers.google.com/+/web/buttons-policy" target="_blank">Google Button Publisher Policies</a>.</p>'||unistr('\000a')||
''
 ,p_version_identifier => '1.0'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 40740137921121652 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 40739742893104145 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'URL to Google+'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'current_page'
 ,p_is_translatable => false
 ,p_help_text => 'Suggest a default URL which will be included in the +1.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40740533823123567 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40740137921121652 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Current Page'
 ,p_return_value => 'current_page'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40740930588125074 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40740137921121652 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Page URL'
 ,p_return_value => 'page_url'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40741327354126528 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40740137921121652 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Custom URL'
 ,p_return_value => 'custom_url'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40741724119128028 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40740137921121652 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Value of Page Item'
 ,p_return_value => 'value'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 40742618499145810 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 40739742893104145 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Page URL'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_display_length => 50
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 40740137921121652 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'page_url'
 ,p_help_text => '<p>Enter a page URL in the Oracle APEX <code>f?p=</code> syntax. See <a href="http://download.oracle.com/docs/cd/E17556_01/doc/user.40/e15517/concept.htm#BEIFCDGF" target="_blank">Understanding URL syntax</a> in the Oracle APEX online documentation.</p>'||unistr('\000a')||
''||unistr('\000a')||
'<p><strong>Note:</strong> You can only reference public pages and you have to use <strong>0</strong> as session id, otherwise the URL will not be identified as the same URL. It''s also not allowed to end the page URL with a colon.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 40743130779155304 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 40739742893104145 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Custom URL'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => 'http://'
 ,p_display_length => 50
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 40740137921121652 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'custom_url'
 ,p_help_text => 'Enter the URL which should be included in the +1.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 40743547804162622 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 40739742893104145 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Size'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'standard'
 ,p_is_translatable => false
 ,p_help_text => 'Sets the +1 button size to render. See <a href="https://developers.google.com/+/web/+1button/#button-sizes" target="_blank">button sizes</a> for more information. '
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40743845863163489 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40743547804162622 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Small'
 ,p_return_value => 'small'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40744242844164929 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40743547804162622 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Medium'
 ,p_return_value => 'medium'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40744640256166116 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40743547804162622 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Standard'
 ,p_return_value => 'standard'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40745037453167395 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40743547804162622 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Tall'
 ,p_return_value => 'tall'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 40745639812181566 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 40739742893104145 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Annotation'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'bubble'
 ,p_is_translatable => false
 ,p_help_text => 'Sets the annotation to display next to the button.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'<strong>None</strong> : Do not render additional annotations.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'<strong>Bubble</strong> : Display the number of users who have +1''d the page in a graphic next to the button.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'<strong>Inline</strong> :  Display profile pictures of connected users who have +1''d the page and a count of users who have +1''d the page.'||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40745938518182128 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40745639812181566 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'None'
 ,p_return_value => 'none'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40746335499183530 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40745639812181566 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Bubble'
 ,p_return_value => 'bubble'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40746734205184097 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40745639812181566 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Inline'
 ,p_return_value => 'inline'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 40747719947221122 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 40739742893104145 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Width'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => true
 ,p_default_value => '450'
 ,p_display_length => 10
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 40745639812181566 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'inline'
 ,p_help_text => 'If Annotation is set to <strong>"Inline"</strong>, this parameter sets the width in pixels to use for the button and its inline annotation. If the width is omitted, a button and its inline annotation use 450px.'||unistr('\000a')||
''||unistr('\000a')||
'See <a href="https://developers.google.com/+/web/+1button/#inline-annotation" target="_blank">Inline annotation widths</a> for examples of how the annotation is displayed for various width settings. '
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 40748042148226032 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 40739742893104145 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Align'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'left'
 ,p_is_translatable => false
 ,p_help_text => 'Sets the horizontal alignment of the button assets within its frame. '
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40748340422226825 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40748042148226032 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Right'
 ,p_return_value => 'right'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40748738481227690 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40748042148226032 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Left'
 ,p_return_value => 'left'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 40749116700237781 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 40739742893104145 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Expand to'
 ,p_attribute_type => 'CHECKBOXES'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_help_text => 'Sets the preferred positions to display hover and confirmation bubbles, which are relative to the button. Set this parameter when your page contains certain elements, such as Flash objects, that might interfere with rendering the bubbles.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'For example, <strong>top</strong> will display the hover and confirmation bubbles above the button.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'If omitted, the rendering logic will guess the best position, usually defaulting to below the button by using the <strong>bottom</strong> value. '
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40749447527238683 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40749116700237781 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Top'
 ,p_return_value => 'top'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40749845586239585 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40749116700237781 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Right'
 ,p_return_value => 'right'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40750244292240263 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40749116700237781 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Bottom'
 ,p_return_value => 'bottom'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 40750642998240861 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 40749116700237781 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Left'
 ,p_return_value => 'left'
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
