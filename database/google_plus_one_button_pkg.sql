create or replace
package google_plus_one_button_pkg
as
-------------------------------------------------------------------------------
	function render_google_plus_one_button (
		p_item					in apex_plugin.t_page_item,
		p_plugin				in apex_plugin.t_plugin,
		p_value					in varchar2,
		p_is_readonly			in boolean,
		p_is_printer_friendly	in boolean
	) return apex_plugin.t_page_item_render_result;
-------------------------------------------------------------------------------
end google_plus_one_button_pkg;
/
create or replace
package body google_plus_one_button_pkg
as
--------------------------------------------------------------------------------
	function render_google_plus_one_button (
		p_item					in apex_plugin.t_page_item,
		p_plugin				in apex_plugin.t_plugin,
		p_value					in varchar2,
		p_is_readonly			in boolean,
		p_is_printer_friendly	in boolean
	) return apex_plugin.t_page_item_render_result
	as
		c_host constant varchar2(4000) := apex_util.host_url('SCRIPT');

		l_url			varchar2(4000);
		l_page_url		varchar2(4000)	:= p_item.attribute_02;
		l_custom_url	varchar2(4000)	:= p_item.attribute_03;
		l_url_to_plus	varchar2(20)	:= coalesce(p_item.attribute_01, 'current_page');
		l_size			varchar2(20)	:= coalesce(p_item.attribute_04, 'standard');
		l_annotation	varchar2(20)	:= coalesce(p_item.attribute_05, 'bubble');
		l_width			varchar2(256)	:= p_item.attribute_06;
		l_align			varchar2(20)	:= coalesce(p_item.attribute_07, 'left');
		l_expandto		varchar2(100)	:= p_item.attribute_08;
		l_result		apex_plugin.t_page_item_render_result;
	begin
		-- Don't show the widget if we are running in printer friendly mode
		if p_is_printer_friendly then
			return null;
		end if;

		-- Generate the Google +1 URL based on our URL setting.
		-- Note: Always use session 0, otherwise Google +1 will always register a different URL.
		l_url := case l_url_to_plus
					when 'current_page' then
						c_host || 'f?p=' || apex_application.g_flow_id || ':' || apex_application.g_flow_step_id || ':0'
					when 'page_url' then
						c_host||l_page_url
					when 'custom_url' then
						replace(l_custom_url, '#HOST#', c_host)
					when 'value' then
						replace(p_value, '#HOST#', c_host)
					end;
		-- Output the Google +1 button widget
		-- See https://developers.google.com/+/web/+1button/ for syntax
		sys.htp.prn (
				'<div class="g-plusone"'
			||	' data-href="' || apex_escape.html_attribute(l_url) || '"'
			||	' data-size="' || apex_escape.html_attribute(l_size) || '"'
			||	' data-annotation="' || apex_escape.html_attribute(l_annotation) || '"'
			||	case when l_annotation = 'inline' then
					' data-width="' || apex_escape.html_attribute(l_annotation) || '"'
				end
			||	' data-align="' || apex_escape.html_attribute(l_align) || '"'
			||	' data-expandTo="' || apex_escape.html_attribute(replace(l_expandto, ':', ',')) || '"'
			||	'></div>'
		);
		apex_javascript.add_library(
			p_name		=> 'platform',
			p_directory	=> 'https://apis.google.com/js/',
			p_key		=> 'com.google.apis.platform'
		);
		-- Tell APEX that this field is NOT navigable
		l_result.is_navigable := false;
		return l_result;
	end render_google_plus_one_button;
--------------------------------------------------------------------------------
end google_plus_one_button_pkg;
/