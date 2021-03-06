﻿<!---
*
* Copyright (C) 2005-2008 Razuna
*
* This file is part of Razuna - Enterprise Digital Asset Management.
*
* Razuna is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Razuna is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero Public License for more details.
*
* You should have received a copy of the GNU Affero Public License
* along with Razuna. If not, see <http://www.gnu.org/licenses/>.
*
* You may restribute this Program with a special exception to the terms
* and conditions of version 3.0 of the AGPL as described in Razuna's
* FLOSS exception. You should have received a copy of the FLOSS exception
* along with Razuna. If not, see <http://www.razuna.com/licenses/>.
*
--->

<cfoutput>
	<cfparam name="attributes.bot" default="false" />
	<cfparam name="attributes.sortby" default="name" />
	
	<cfif kind EQ "img">
		<cfset thefa = "c.folder_images">
		<cfset thediv = "img">
	<cfelseif kind EQ "vid">
		<cfset thefa = "c.folder_videos">
		<cfset thediv = "vid">
	<cfelseif kind EQ "aud">
		<cfset thefa = "c.folder_audios">
		<cfset thediv = "aud">
	<cfelseif kind EQ "all">
		<cfset thefa = "c.labels_main_assets">
		<cfset thediv = "lab_content">
	<cfelseif kind EQ "doc">
		<cfset thefa = "c.folder_files">
		<cfset thediv = "doc">
	<cfelseif kind EQ "pdf">
		<cfset thefa = "c.folder_files">
		<cfset thediv = "pdf">
	<cfelseif kind EQ "xls">
		<cfset thefa = "c.folder_files">
		<cfset thediv = "xls">
	<cfelse>
		<cfset thefa = "c.folder_files">
		<cfset thediv = "other">
	</cfif>
	
	<cfset qry_labelcount.thetotal = qry_labels_count.count_assets>
	
	<table border="0" width="100%" cellspacing="0" cellpadding="0" class="gridno">
		<tr>
		
			<div id="feedback_delete_#kind#" style="white-space:no-wrap;"></div><div id="dummy_#kind#" style="display:none;"></div>
			<!--- Next and Back --->
			<td align="right" width="100%" nowrap="true">
				<cfif session.offset GTE 1>
					<!--- For Back --->
					<cfset newoffset = session.offset - 1>
					<a href="##" onclick="loadcontent('#thediv#','#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=#newoffset#');">&lt; #myFusebox.getApplicationData().defaults.trans("back")#</a> |
				</cfif>
				
				<cfset showoffset = session.offset * session.rowmaxpage>
				<cfset shownextrecord = (session.offset + 1) * session.rowmaxpage>
				<cfif qry_labelcount.thetotal GT session.rowmaxpage>#showoffset# - #shownextrecord#</cfif>
				<cfif qry_labelcount.thetotal GT session.rowmaxpage AND NOT shownextrecord GTE qry_labelcount.thetotal> | 
					<!--- For Next --->
					<cfset newoffset = session.offset + 1>
					<a href="##" onclick="loadcontent('#thediv#','#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=#newoffset#');">#myFusebox.getApplicationData().defaults.trans("next")# &gt;</a>
				</cfif>
				<!--- Pages --->
				<cfif attributes.bot eq "true">
					<cfif qry_labelcount.thetotal GT session.rowmaxpage>
						<span style="padding-left:10px;">
							<cfset thepage = ceiling(qry_labelcount.thetotal / session.rowmaxpage)>
							Page: 
								<select class="thepagelist#kind#" onChange="loadcontent('#thediv#', $('.thepagelist#kind# :selected').val());">
								<cfloop from="1" to="#thepage#" index="i">
									<cfset loopoffset = i - 1>
									<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=#loopoffset#"<cfif (session.offset + 1) EQ i> selected</cfif>>#i#</option>
								</cfloop>
								</select>
						</span>
					</cfif>
				<cfelse>
					<cfif qry_labelcount.thetotal GT session.rowmaxpage>
						<span style="padding-left:10px;">
							<cfset thepage = ceiling(qry_labelcount.thetotal / session.rowmaxpage)>
							Page: 
								<select id="thepagelist#kind#" onChange="loadcontent('#thediv#', $('##thepagelist#kind# :selected').val());">
								<cfloop from="1" to="#thepage#" index="i">
									<cfset loopoffset = i - 1>
									<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=#loopoffset#"<cfif (session.offset + 1) EQ i> selected</cfif>>#i#</option>
								</cfloop>
								</select>
						</span>
					</cfif>
				</cfif>
			</td>
			<!--- Sort by --->
			<cfif attributes.bot eq "true">
				<td align="right" width="1%" nowrap="true">
					<cfif qry_labelcount.thetotal neq 0>
					Sort by: 
					 <select name="selectsortby#kind#" id="selectsortby#kind#" onChange="changesortby('selectsortby#kind#');" style="width:100px;">
					 	<option value="name"<cfif session.sortby EQ "name"> selected="selected"</cfif>>Name</option>
					 	<cfif kind EQ "all"><option value="kind"<cfif session.sortby EQ "kind"> selected="selected"</cfif>>Type of Asset</option></cfif>
					 	<option value="sizedesc"<cfif session.sortby EQ "sizedesc"> selected="selected"</cfif>>Size (Descending)</option>
					 	<option value="sizeasc"<cfif session.sortby EQ "sizeasc"> selected="selected"</cfif>>Size (Ascending)</option>
					 	<option value="dateadd"<cfif session.sortby EQ "dateadd"> selected="selected"</cfif>>Date Added</option>
					 	<option value="datechanged"<cfif session.sortby EQ "datechanged"> selected="selected"</cfif>>Last Changed</option>
					 	<option value="hashtag"<cfif session.sortby EQ "hashtag"> selected="selected"</cfif>>Same file</option>
					 </select>
					</cfif>
				</td>
			<cfelse>
				<td align="right" width="1%" nowrap="true">
					<cfif qry_labelcount.thetotal neq 0>
					Sort by: 
					 <select name="selectsortby#kind#<cfif structkeyexists(attributes,"bot")>b</cfif>" id="selectsortby#kind#<cfif structkeyexists(attributes,"bot")>b</cfif>" onChange="changesortby('selectsortby#kind#<cfif structkeyexists(attributes,"bot")>b</cfif>');" style="width:100px;">
					 	<option value="name"<cfif session.sortby EQ "name"> selected="selected"</cfif>>Name</option>
					 	<cfif kind EQ "all"><option value="kind"<cfif session.sortby EQ "kind"> selected="selected"</cfif>>Type of Asset</option></cfif>
					 	<option value="sizedesc"<cfif session.sortby EQ "sizedesc"> selected="selected"</cfif>>Size (Descending)</option>
					 	<option value="sizeasc"<cfif session.sortby EQ "sizeasc"> selected="selected"</cfif>>Size (Ascending)</option>
					 	<option value="dateadd"<cfif session.sortby EQ "dateadd"> selected="selected"</cfif>>Date Added</option>
					 	<option value="datechanged"<cfif session.sortby EQ "datechanged"> selected="selected"</cfif>>Last Changed</option>
					 	<option value="hashtag"<cfif session.sortby EQ "hashtag"> selected="selected"</cfif>>Same file</option>
					 </select>
					</cfif>
				</td>
			</cfif>
			<!--- Change the amount of images shown --->
			<cfif attributes.bot eq "true">
				<td align="right" width="1%" nowrap="true">
					<cfif qry_labelcount.thetotal GT session.rowmaxpage OR qry_labelcount.thetotal GT 25>
						<select name="selectrowperpage#kind#" id="selectrowperpage#kind#" onChange="changerow('#thediv#','selectrowperpage#kind#')" style="width:80px;">
						<option value="javascript:return false;">Show how many...</option>
						<option value="javascript:return false;">---</option>
						<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=0&rowmaxpage=25"<cfif session.rowmaxpage EQ 25> selected="selected"</cfif>>25</option>
						<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=0&rowmaxpage=50"<cfif session.rowmaxpage EQ 50> selected="selected"</cfif>>50</option>
						<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=0&rowmaxpage=75"<cfif session.rowmaxpage EQ 75> selected="selected"</cfif>>75</option>
						<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=0&rowmaxpage=100"<cfif session.rowmaxpage EQ 100> selected="selected"</cfif>>100</option>
						</select>
					</cfif>
				</td>
			<cfelse>
				<td align="right" width="1%" nowrap="true">
					<cfif qry_labelcount.thetotal GT session.rowmaxpage OR qry_labelcount.thetotal GT 25>
						<select name="selectrowperpage#kind#<cfif structkeyexists(attributes,"bot")>b</cfif>" id="selectrowperpage#kind#<cfif structkeyexists(attributes,"bot")>b</cfif>" onChange="changerow('#thediv#','selectrowperpage#kind#<cfif structkeyexists(attributes,"bot")>b</cfif>')" style="width:80px;">
						<option value="javascript:return false;">Show how many...</option>
						<option value="javascript:return false;">---</option>
						<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=0&rowmaxpage=25"<cfif session.rowmaxpage EQ 25> selected="selected"</cfif>>25</option>
						<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=0&rowmaxpage=50"<cfif session.rowmaxpage EQ 50> selected="selected"</cfif>>50</option>
						<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=0&rowmaxpage=75"<cfif session.rowmaxpage EQ 75> selected="selected"</cfif>>75</option>
						<option value="#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&offset=0&rowmaxpage=100"<cfif session.rowmaxpage EQ 100> selected="selected"</cfif>>100</option>
						</select>
					</cfif>
				</td>
			</cfif>
		</tr>
	</table>
	<script language="javascript">
		// Change the sortby
		function changesortby(theselect){
			// Get selected option
			var thesortby = $('##' + theselect + ' option:selected').val();
			loadcontent('#thediv#','#myself##thefa#&label_id=#attributes.label_id#&label_kind=#attributes.label_kind#&_=#attributes._#&sortby=' + thesortby);
		}
	</script>

</cfoutput>
