<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="LogToHtmlCommon.xslt"/>
	<xsl:output version="4.0" method="html" indent="no" encoding="utf-8"/>
	<xsl:template match="project">
		<span class="Project">
			<xsl:text/>Project: <xsl:value-of select="@file"/>; Targets: <xsl:value-of select="@targets"/> 
		</span>
		<br/>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="target">
		<xsl:variable name="spanClass">
			<xsl:choose>
				<xsl:when test="starts-with(@name, '_')">SubTarget LowImportance</xsl:when>
				<xsl:otherwise>Target</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<span class="{$spanClass}">
			<xsl:text/>Target <xsl:value-of select="@name"/> in <xsl:value-of select="ancestor::project/@file"/>
		</span>
		<br/>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="message[@importance='High']">
		<span class="HighImportance">
			<xsl:value-of select="."/>
			<br/>
		</span>
	</xsl:template>
	<xsl:template match="message[@importance='Normal']">
		<span class="NormalImportance">
			<xsl:value-of select="."/>
			<br/>
		</span>
	</xsl:template>
	<xsl:template match="message[@importance='Low']">
		<span class="LowImportance" style="display:none">
			<xsl:value-of select="."/>
			<br/>
		</span>
	</xsl:template>
	<xsl:template match="error">
		<a name="{generate-id(.)}"/>
		<span class="Error">
			<xsl:apply-templates select="." mode="errorMessage"/>
		</span>
	</xsl:template>
	<xsl:template match="warning">
		<a name="{generate-id(.)}"/>
		<span class="Warning">
			<xsl:apply-templates select="." mode="errorMessage"/>
		</span>
	</xsl:template>
	<xsl:template match="/">
		<html>
			<head>
				<title/>
				<xsl:call-template name="scripts"/>
				<xsl:call-template name="style"/>
			</head>
			<body>
				<xsl:call-template name="listErrorCategories">
					<xsl:with-param name="collapsed" select="'true'"/>
				</xsl:call-template>
				<input type="checkbox" onclick="ToggleLowImportanceText();"/>Low importance text<br/>
				<hr/>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
