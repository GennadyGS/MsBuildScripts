<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output version="4.0" method="html" indent="no" encoding="utf-8"/>
	<xsl:template name="style">
		<style>
				.LowImportance{
					color : silver;
				}
				.NormalImportance{
					color : black;
				}
				.HighImportance{
					color : black;
					font-weight : bold;
				}
				.Error{
					color : red;
					font-weight : bold;
				}
				.Warning{
					color : teal;
					font-weight : bold;
				}
				.Project{
					color : black;
					font-weight : bold;
				}
				.Target{
					color : black;
					font-weight : bold;
				}
				.SubTarget{
					color : silver;
				}
		</style>
	</xsl:template>
	<xsl:template name="scripts">
		<script>
			  function ToggleLowImportanceText(){
				  var spans = document.getElementsByTagName('span');
				  for(var index in spans){
				    var element = spans[index];
				    if((/span/i.test(element.nodeName)) &amp;&amp; (element.className == 'LowImportance')){
					  if(element.style.display == 'none')
					    element.style.display = '';
					  else
					    element.style.display = 'none';
				    }
				  }
			  }
			  function ToggleExpandBlock(aID){
				  var element = document.getElementById(aID);
				  if(element.style.display == 'none')
				    element.style.display = '';
				  else
				    element.style.display = 'none';
			  }
		</script>
	</xsl:template>
	<xsl:template mode="errorMessage" match="error | warning">
		<xsl:value-of select="@file"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="@line"/>
		<xsl:text>): </xsl:text>
		<xsl:value-of select="@subcategory"/>
		<xsl:text>&#x20;</xsl:text>
		<xsl:value-of select="name(.)"/>
		<xsl:text>&#x20;</xsl:text>
		<xsl:value-of select="@code"/>
		<xsl:text>: </xsl:text>
		<xsl:value-of select="."/>
		<br/>
	</xsl:template>
	<xsl:template name="checkWrapContentWithLink">
		<xsl:param name="content"/>
		<xsl:param name="wrap"/>
		<xsl:param name="linkRef"/>
		<xsl:param name="class"/>
		<xsl:choose>
			<xsl:when test="$wrap">
				<a href="{$linkRef}" class="{$class}">
					<xsl:value-of select="$content"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<span class="{$class}">
					<xsl:value-of select="$content"/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="listErrors">
		<xsl:param name="nodes"/>
		<xsl:param name="category"/>
		<xsl:param name="collapsed"/>
		<xsl:variable name="summary">
			<xsl:value-of select="$category"/>: <xsl:value-of select="count($nodes)"/>
		</xsl:variable>
		<xsl:variable name="expandLinkRef">
			<xsl:text>javascript:ToggleExpandBlock('</xsl:text>
			<xsl:value-of select="$category"/>
			<xsl:text>')</xsl:text>
		</xsl:variable>
		<xsl:call-template name="checkWrapContentWithLink">
			<xsl:with-param name="content" select="$summary"/>
			<xsl:with-param name="wrap" select="($collapsed = 'true') and $nodes"/>
			<xsl:with-param name="linkRef" select="$expandLinkRef"/>
			<xsl:with-param name="class" select="$category"/>
		</xsl:call-template>
		<xsl:if test="$nodes">
			<ol>
				<xsl:if test="$collapsed = 'true'">
					<xsl:attribute name="id">
						<xsl:value-of select="$category"/>
					</xsl:attribute>
					<xsl:attribute name="style">
						<xsl:text>display:none</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<xsl:for-each select="$nodes">
					<li>
						<xsl:variable name="errorMessage">
							<xsl:apply-templates select="." mode="errorMessage"/>
						</xsl:variable>
						<xsl:call-template name="checkWrapContentWithLink">
							<xsl:with-param name="content" select="$errorMessage"/>
							<xsl:with-param name="wrap" select="$collapsed"/>
							<xsl:with-param name="linkRef" select="concat('#', generate-id(.))"/>
							<xsl:with-param name="class" select="$category"/>
						</xsl:call-template>
					</li>
				</xsl:for-each>
			</ol>
		</xsl:if>
	</xsl:template>
	<xsl:template name="listErrorCategories">
		<xsl:param name="collapsed"/>
		<ul>
			<li>
				<xsl:call-template name="listErrors">
					<xsl:with-param name="nodes" select="/descendant::error"/>
					<xsl:with-param name="category" select="'Error'"/>
					<xsl:with-param name="collapsed" select="$collapsed"/>
				</xsl:call-template>
			</li>
			<li>
				<xsl:call-template name="listErrors">
					<xsl:with-param name="nodes" select="/descendant::warning"/>
					<xsl:with-param name="category" select="'Warning'"/>
					<xsl:with-param name="collapsed" select="$collapsed"/>
				</xsl:call-template>
			</li>
		</ul>
	</xsl:template>
</xsl:stylesheet>
