<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="2.0">
  <xsl:import href="diffspec-tech.xsl"/>
	<xsl:param name="output.dir" select="'.'"/>
	<xsl:param name="output.dir.prefix" select="'file:///'"/>
	<xsl:param name="slices" select="1"/>
	<xsl:param name="show.diff.markup" select="'0'"/>
	
  <xsl:template name="href.target">
    <xsl:param name="target" select="."/>
    <xsl:variable name="slice" select="($target/ancestor-or-self::div1[not(@diff = 'del')] | 
    $target/ancestor-or-self::inform-div1[not(@diff = 'del')]  | $target/ancestor-or-self::technique[not(@diff = 'del')] | $target/ancestor-or-self::div2[not(@diff = 'del')][ancestor::body]  | $target/ancestor-or-self::spec)[last()]"/>
    <xsl:apply-templates select="$slice" mode="slice-techniques-filename"/>
    <xsl:if test="$target != $slice">
      <xsl:text>#</xsl:text>
      <xsl:choose>
        <xsl:when test="$target/@id">
          <xsl:value-of select="$target/@id"/>
        </xsl:when>
        <xsl:otherwise>
        	<xsl:message terminate="yes">Generating ID for <xsl:value-of select="."/></xsl:message>
          <xsl:value-of select="generate-id($target)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
<!-- Note: slice filename templates moved to xmlspec-wcag.xsl, so they can be used to create cross reference links. Also mode name changed to "slice-techniques-filename" -->
  
  <!-- create a separate page for the introduction -->
  <xsl:template match="front/div1">
  <xsl:choose>
      <xsl:when test="$slices= 0"/>
      <xsl:otherwise>
    <xsl:variable name="prev" select="(preceding::div1)[last()]"/>
    <xsl:variable name="next" select="(following::technique | following::div2)[1]"/>
      	<xsl:variable name="filename"><xsl:apply-templates select="." mode="slice-techniques-filename"/></xsl:variable>
      	<xsl:result-document method="xml" href="{$output.dir.prefix}{$output.dir}/{$filename}" encoding="UTF-8" doctype-system="about:legacy-compat" indent="no">
        <html>
        	<xsl:if test="/spec/header/langusage/language">
        		<xsl:attribute name="lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
        		<xsl:attribute name="xml:lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
        	</xsl:if>
        	<head>
        	<meta charset="UTF-8"/>
            <title>
              <xsl:apply-templates select="head" mode="text"/>  | WCAG 2.0 達成方法集
            </title>
        		<xsl:call-template name="canonical-link"/>
            <link rel="stylesheet" type="text/css" href="slicenav.css"/>
            <xsl:if test="$show.diff.markup != 0">
              <script type="text/javascript" src="diffmarks.js"><xsl:text> </xsl:text></script>
            </xsl:if>
            <xsl:call-template name="css"/>
          </head>
         <body class="slices toc-inline">
          <xsl:if test="$show.diff.markup != 0">
            <xsl:attribute name="onload">jscheck()</xsl:attribute>
          </xsl:if>
<xsl:call-template name="skipnav"></xsl:call-template>
            
            <xsl:call-template name="navigation.top">
              <xsl:with-param name="prev" select="$prev"/>
              <xsl:with-param name="next" select="$next"/>
            </xsl:call-template>
            <div class="div1">
              <xsl:apply-templates/>
            </div>
            <!--<xsl:call-template name="informative.disclaimer"/>-->
            <xsl:call-template name="navigation.bottom">
              <xsl:with-param name="prev" select="(preceding::div1)[last()]"/>
              <xsl:with-param name="next" select="(following::technique | following::div2)[1]"/>
            </xsl:call-template>
            <xsl:call-template name="footer"></xsl:call-template>
          </body>
        </html>
      		</xsl:result-document>
    </xsl:otherwise></xsl:choose>
  </xsl:template>
  <!-- create Technology Collection Pages -->
  <xsl:template match="body/div1" >
  	<xsl:variable name="filename">
  		<xsl:apply-templates select="." mode="slice-techniques-filename"/>
  	</xsl:variable>
  	<xsl:result-document method="xml" href="{$output.dir.prefix}{$output.dir}/{$filename}" encoding="UTF-8" doctype-system="about:legacy-compat" indent="no">
        <html>
        	<xsl:if test="/spec/header/langusage/language">
        		<xsl:attribute name="lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
        		<xsl:attribute name="xml:lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
        	</xsl:if>
        	<head>
        	<meta charset="UTF-8"/>
            <title>
              <xsl:apply-templates select="head" mode="text"/>  | WCAG 2.0 達成方法集
            </title>
        		<xsl:call-template name="canonical-link"/>
            <link rel="stylesheet" type="text/css" href="slicenav.css"/>
            <xsl:if test="$show.diff.markup != 0">
              <script type="text/javascript" src="diffmarks.js"><xsl:text> </xsl:text></script>
            </xsl:if>
            <xsl:call-template name="css"/>
          </head>
            <body class="slices toc-inline">
          <xsl:if test="$show.diff.markup != 0">
            <xsl:attribute name="onload">jscheck()</xsl:attribute>
          </xsl:if>
<xsl:call-template name="skipnav"></xsl:call-template>
            <xsl:call-template name="navigation.top">
            </xsl:call-template>
            <!-- Need to figure out how to apply the template below with the slices parameter set to 0 -->
            <div class="div1">
            <xsl:choose>
      <xsl:when test="$slices= 0"><xsl:apply-templates />
    </xsl:when>
    <xsl:otherwise>
    	@@ re-run build-wcag script with the bytech parameter set to "1" for each technology collection</xsl:otherwise>
    </xsl:choose>
            </div>  
            	<xsl:if test="$show.diff.markup != 0">
            		<div class="diff-delete"><span class="difftext">[begin delete] </span>
            			<xsl:call-template name="techniques.informative.disclaimer"/>
            			<span class="difftext">[end delete]</span></div>
            	</xsl:if>
            	<xsl:call-template name="navigation.bottom"/>
            <xsl:call-template name="footer"/>
          </body>
        </html>
  		</xsl:result-document>
  	<xsl:apply-templates select="div2 | technique"/>
  </xsl:template>
    <!-- Create pages for the techniques chunks-->
    <xsl:template match="technique">
      <xsl:variable name="prev" select="(preceding::div1[not(@diff = 'del')] | preceding::technique[not(@diff = 'del')] | preceding::div2[not(@diff = 'del')] | preceding::div1[@id!='placeholders'])[last()]"/>
      <xsl:variable name="next" select="(following::technique[not(@diff = 'del')] | following::div2[not(@diff = 'del')] | following::inform-div1[not(@diff = 'del')])[1]"/>
    	<xsl:variable name="filename">
    		<xsl:apply-templates select="." mode="slice-techniques-filename"/>
    	</xsl:variable>
    	<xsl:result-document method="xml" href="{$output.dir.prefix}{$output.dir}/{$filename}" encoding="UTF-8" doctype-system="about:legacy-compat" indent="no">
    	    <html>
    	    	<xsl:if test="/spec/header/langusage/language">
    	    		<xsl:attribute name="lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
    	    		<xsl:attribute name="xml:lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
    	    	</xsl:if>
    	    	<head>
              <meta charset="UTF-8"/>
              <title>
								<xsl:value-of select="@id"></xsl:value-of>:<xsl:text> </xsl:text><xsl:apply-templates select="short-name" mode="text"/> | WCAG 2.0 達成方法集
              </title>
    	    		<xsl:call-template name="canonical-link"/>
              <xsl:call-template name="css"/>
              <link rel="stylesheet" type="text/css" href="slicenav.css"/>
              <xsl:if test="$show.diff.markup != 0">
              <script type="text/javascript" src="diffmarks.js"><xsl:text> </xsl:text></script>
            </xsl:if>
            </head>
            <body class="slices toc-inline">
          <xsl:if test="$show.diff.markup != 0">
            <xsl:attribute name="onload">jscheck()</xsl:attribute>
          </xsl:if>
<xsl:call-template name="skipnav"></xsl:call-template>
              <xsl:call-template name="navigation.top">
                <xsl:with-param name="prev" select="$prev"/>
                <xsl:with-param name="next" select="$next"/>
              </xsl:call-template>
<!-- Quick TOC for Techniques (@@ needs update) -->
<div class="navtoc">
<p>このページのコンテンツ:</p>    
                <xsl:apply-templates mode="techniquetoc" select=".">
                  <xsl:with-param name="just.filename" select="'1'"/>
                </xsl:apply-templates>
              </div>
            	<xsl:apply-templates/>
            	<xsl:if test="$show.diff.markup != 0">
	            	<div class="diff-delete"><span class="difftext">[begin delete] </span>
	            	<xsl:call-template name="techniques.informative.disclaimer"/>
	            	<span class="difftext">[end delete]</span></div>
            	</xsl:if>
              <xsl:call-template name="navigation.bottom">
                <xsl:with-param name="prev" select="(preceding::div1[not(@diff = 'del')] | preceding::technique[not(@diff = 'del')] | preceding::div2[not(@diff = 'del')] | preceding::div1[@id!='placeholders'])[last()]"/>
                <xsl:with-param name="next" select="(following::technique[not(@diff = 'del')] | following::div2[not(@diff = 'del')] |following::inform-div1[not(@diff = 'del')])[1]"/>
              </xsl:call-template>
              <xsl:call-template name="footer"></xsl:call-template>
            </body>
          </html>
    		</xsl:result-document>
    </xsl:template>

    <!-- Create pages for techniques intro-->
    <xsl:template match="body/div1/div2">
      <xsl:variable name="prev" select="(preceding::div1[not(@diff = 'del')] | preceding::technique[not(@diff = 'del')] | preceding::div2[not(@diff = 'del')] | preceding::div1[@id!='placeholders'])[last()]"/>
      <xsl:variable name="next" select="(following::technique[not(@diff = 'del')] | following::div2[not(@diff = 'del')])[1]"/>
    	<xsl:variable name="filename">
    		<xsl:apply-templates select="." mode="slice-techniques-filename"/>
    	</xsl:variable>
    	<xsl:result-document method="xml" href="{$output.dir.prefix}{$output.dir}/{$filename}" encoding="UTF-8" doctype-system="about:legacy-compat" indent="no">
    	    <html>
    	    	<xsl:if test="/spec/header/langusage/language">
    	    		<xsl:attribute name="lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
    	    		<xsl:attribute name="xml:lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
    	    	</xsl:if>
    	    	<head>
              <meta charset="UTF-8"/>
              <title>
				<xsl:apply-templates select="head" mode="text"/> | WCAG 2.0 達成方法集
              </title>
    	    		<xsl:call-template name="canonical-link"/>
              <xsl:call-template name="css"/>
              <link rel="stylesheet" type="text/css" href="slicenav.css"/>
              <xsl:if test="$show.diff.markup != 0">
              <script type="text/javascript" src="diffmarks.js"><xsl:text> </xsl:text></script>
            </xsl:if>
            </head>
            <body class="slices toc-inline">
          <xsl:if test="$show.diff.markup != 0">
            <xsl:attribute name="onload">jscheck()</xsl:attribute>
          </xsl:if>
<xsl:call-template name="skipnav"></xsl:call-template>
              <xsl:call-template name="navigation.top">
                <xsl:with-param name="prev" select="$prev"/>
                <xsl:with-param name="next" select="$next"/>
              </xsl:call-template>
            	
            	<!-- This template is the same as the technique template, except removed the quick nav from here -->
              <xsl:apply-templates/>
             
              <xsl:call-template name="navigation.bottom">
                <xsl:with-param name="prev" select="(preceding::div1[not(@diff = 'del')] | preceding::technique[not(@diff = 'del')] | preceding::div2[not(@diff = 'del')] | preceding::div1[@id!='placeholders'])[last()]"/>
                <xsl:with-param name="next" select="(following::technique[not(@diff = 'del')] | following::div2[not(@diff = 'del')] |following::inform-div1[not(@diff = 'del')])[1]"/>
              </xsl:call-template>
              <xsl:call-template name="footer"></xsl:call-template>
            </body>
          </html>
    		</xsl:result-document>
    </xsl:template>

	<xsl:template match="back/div1 | back/inform-div1">
    <xsl:choose>
      <xsl:when test="$slices= 0"/>
      <xsl:otherwise>
    <xsl:variable name="prev" select="(preceding::technique[not(@diff = 'del')] | preceding::inform-div1[not(@diff = 'del')])[last()]"/>
    <xsl:variable name="next" select="(following::div1[not(@diff = 'del')] | following::inform-div1[not(@diff = 'del')])[1]"/>
      	<xsl:variable name="filename">
      		<xsl:apply-templates select="." mode="slice-techniques-filename"/>
      	</xsl:variable>
      	<xsl:result-document method="xml" href="{$output.dir.prefix}{$output.dir}/{$filename}" encoding="UTF-8" doctype-system="about:legacy-compat" indent="no">
      	    <html>
      	    	<xsl:if test="/spec/header/langusage/language">
      	    		<xsl:attribute name="lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
      	    		<xsl:attribute name="xml:lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
      	    	</xsl:if>
      	    	<head>
            <meta charset="UTF-8"/>
            <title>
              <xsl:apply-templates select="head" mode="text"/>
              <xsl:text> </xsl:text> | WCAG 2.0 達成方法集
            </title>
      	    		<xsl:call-template name="canonical-link"/>
            <link rel="stylesheet" type="text/css" href="slicenav.css"/>
            <xsl:if test="$show.diff.markup != 0">
              <script type="text/javascript" src="diffmarks.js"><xsl:text> </xsl:text></script>
            </xsl:if>
            <xsl:call-template name="css"/>
          </head>
          <body class="slices toc-inline">
          <xsl:if test="$show.diff.markup != 0">
            <xsl:attribute name="onload">jscheck()</xsl:attribute>
          </xsl:if>
<xsl:call-template name="skipnav"></xsl:call-template>
            <xsl:call-template name="navigation.top">
              <xsl:with-param name="prev" select="$prev"/>
              <xsl:with-param name="next" select="$next"/>
            </xsl:call-template>
            <div class="div1">
              <xsl:apply-templates/>
            </div>
            

            <xsl:call-template name="navigation.bottom">
              <xsl:with-param name="prev" select="(preceding::technique[not(@diff = 'del')] | preceding::div2[not(@diff = 'del')] | preceding::inform-div1[not(@diff = 'del')])[last()]"/>
              <xsl:with-param name="next" select="(following::div1[not(@diff = 'del')] | following::div2[not(@diff = 'del')] | following::inform-div1[not(@diff = 'del')])[1]"/>
            </xsl:call-template>
            <xsl:call-template name="footer"></xsl:call-template>
          </body>
        </html>
      		</xsl:result-document>
    </xsl:otherwise></xsl:choose>
  </xsl:template>
  <xsl:template match="inform-div1">
    <xsl:choose>
      <xsl:when test="$slices= 0"/>
      <xsl:otherwise>
    <xsl:variable name="prev" select="(preceding::div1[not(@diff = 'del')]|preceding::inform-div1[not(@diff = 'del')])[last()]"/>
    <xsl:variable name="next" select="(following::div1[not(@diff = 'del')]|following::inform-div1[not(@diff = 'del')])[1]"/>
      	<xsl:variable name="filename">
      		<xsl:apply-templates select="." mode="slice-techniques-filename"/>
      	</xsl:variable>
      	<xsl:result-document method="xml" href="{$output.dir.prefix}{$output.dir}/{$filename}" encoding="UTF-8" doctype-system="about:legacy-compat" indent="no">
      	    <html>
      	    	<xsl:if test="/spec/header/langusage/language">
      	    		<xsl:attribute name="lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
      	    		<xsl:attribute name="xml:lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
      	    	</xsl:if>
      	    	<head>
            <meta charset="UTF-8"/>
            <title>
              <xsl:apply-templates select="head" mode="text"/> | WCAG 2.0 達成方法集
						</title>
      	    		<xsl:call-template name="canonical-link"/>
            <link rel="stylesheet" type="text/css" href="slicenav.css"/>
            <xsl:if test="$show.diff.markup != 0">
              <script type="text/javascript" src="diffmarks.js"><xsl:text> </xsl:text></script>
            </xsl:if>
            <xsl:call-template name="css"/>
          </head>
          <body class="slices toc-inline">
          <xsl:if test="$show.diff.markup != 0">
            <xsl:attribute name="onload">jscheck()</xsl:attribute>
          </xsl:if>
<xsl:call-template name="skipnav"></xsl:call-template>
            <xsl:call-template name="navigation.top">
              <xsl:with-param name="prev" select="$prev"/>
              <xsl:with-param name="next" select="$next"/>
            </xsl:call-template>
            <div class="div1">
              <xsl:apply-templates/>
            </div>
            <xsl:call-template name="navigation.bottom">
              <xsl:with-param name="prev" select="$prev"/>
              <xsl:with-param name="next" select="$next"/>
            </xsl:call-template>
            <xsl:call-template name="footer"></xsl:call-template>
          </body>
        </html>
      		</xsl:result-document>
    </xsl:otherwise></xsl:choose>
  </xsl:template>
  <xsl:template match="spec">
  	<xsl:variable name="filename">
  		<xsl:apply-templates select="." mode="slice-techniques-filename"/>
  	</xsl:variable>
  	<xsl:result-document method="xml" href="{$output.dir.prefix}{$output.dir}/{$filename}" encoding="UTF-8" doctype-system="about:legacy-compat" indent="no">
        <html>
        	<xsl:if test="/spec/header/langusage/language">
        		<xsl:attribute name="lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
        		<xsl:attribute name="xml:lang"><xsl:value-of select="/spec/header/langusage/language/@id"/></xsl:attribute>
        	</xsl:if>
        	<head>
            <meta charset="UTF-8"/>
            <title>
              <xsl:value-of select="header/title"/>
              <xsl:if test="header/version">
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="header/version"/>
              </xsl:if>
            </title>
        		<xsl:call-template name="canonical-link"/>
                      <link rel="stylesheet" type="text/css" href="additional.css"/>
            <xsl:call-template name="css"/>
          </head>
          <body>
            <a name="top"><xsl:text> </xsl:text> </a>
            <xsl:apply-templates/>
            <xsl:if test="//footnote">
              <hr/>
              <div class="endnotes">
                <h3>
                  <a name="endnotes">
                    <xsl:text>End Notes</xsl:text>
                  </a>
                </h3>
                <dl>
                  <xsl:apply-templates select="//footnote" mode="notes"/>
                </dl>
              </div>
            </xsl:if>
            <xsl:variable name="next" select="(descendant::technique[not(@diff = 'del')] | descendant::div2[not(@diff = 'del')])[1]"/>
            <xsl:call-template name="navigation.bottom">
              <xsl:with-param name="next" select="$next"/>
            </xsl:call-template>
            <!--xsl:call-template name="footer"></xsl:call-template-->
            <script src="https://www.w3.org/scripts/TR/2016/fixup.js"><xsl:text> </xsl:text></script>
            <script src="https://waic.jp/docs/js/translation-contact.js"><xsl:text> </xsl:text></script>
          </body>
        </html>
  		</xsl:result-document>
  </xsl:template>
  <!-- top navigation template-->
  <xsl:template name="navigation.top">
    <xsl:param name="prev" select="''"/>
    <xsl:param name="next" select="''"/>
    <a name="top" >
      <xsl:text> </xsl:text>
    </a>
    <xsl:comment> TOP NAVIGATION BAR </xsl:comment>
    <ul id="navigation" >
      <li>
        <strong><a href="Overview.html#contents" title="Table of Contents">目次</a></strong>
      </li>
      <li>
        <strong><a href="intro.html" title="Introduction to Techniques for WCAG 2.0"><abbr title="Introduction">イントロダクション</abbr></a></strong>
      </li>
      <xsl:choose>
        <xsl:when test="$prev">
          <li>
            <a>
              <xsl:attribute name="title"><xsl:call-template name="href.nav"><xsl:with-param name="target" select="$prev"/></xsl:call-template></xsl:attribute>
              <xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="target" select="$prev"/><!--<xsl:with-param name="just.filename" select="1"/>--></xsl:call-template></xsl:attribute>
             <xsl:element name="strong">前:<xsl:text> </xsl:text></xsl:element>
                <xsl:call-template name="href.nav.short">
                <xsl:with-param name="target" select="$prev"/>
              </xsl:call-template>
            </a>
          </li>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$next">
          <li >
            <a>
              <xsl:attribute name="title"><xsl:call-template name="href.nav"><xsl:with-param name="target" select="$next"/></xsl:call-template></xsl:attribute>
              <xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="target" select="$next"/><!--<xsl:with-param name="just.filename" select="1"/>--></xsl:call-template></xsl:attribute>
              <xsl:element name="strong">次:<xsl:text> </xsl:text></xsl:element>
              <xsl:call-template name="href.nav.short">
                <xsl:with-param name="target" select="$next"/>
              </xsl:call-template>
            </a>
          </li>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </ul>
    <!-- quick table of contents 
		<hr />
		<strong >Quick Table of Contents</strong>
		<hr />
		<ul class="toc" >
			<xsl:apply-templates mode="toc" select=".">
				<xsl:with-param name="just.filename" select="'0'"/>
			</xsl:apply-templates>
		</ul>-->
  </xsl:template>
  <!-- bottom navigation template-->
  <xsl:template name="navigation.bottom">
    <xsl:param name="prev" select="''"/>
    <xsl:param name="next" select="''"/>
    <xsl:comment> BOTTOM NAVIGATION BAR </xsl:comment>
    <ul id="navigationbottom" >
      <li>
        <strong><a href="#top">このページの先頭へ</a></strong>
      </li>
      <li>
        <strong><a href="Overview.html#contents" title="Table of Contents">目次</a></strong>
      </li>
      <li>
        <strong><a href="intro.html" title="Introduction to Techniques for WCAG 2.0"><abbr title="Introduction">イントロダクション</abbr></a></strong>
      </li>
      <xsl:choose>
        <xsl:when test="$prev">
          <li>
            <a>
              <xsl:attribute name="title"><xsl:call-template name="href.nav"><xsl:with-param name="target" select="$prev"/></xsl:call-template></xsl:attribute>
              <xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="target" select="$prev"/><!--<xsl:with-param name="just.filename" select="1"/>--></xsl:call-template></xsl:attribute>
              <xsl:element name="strong">前:<xsl:text> </xsl:text></xsl:element>
              <xsl:call-template name="href.nav.short">
                <xsl:with-param name="target" select="$prev"/>
              </xsl:call-template>
            </a>
          </li>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$next">
          <li>
            <a>
              <xsl:attribute name="title"><xsl:call-template name="href.nav"><xsl:with-param name="target" select="$next"/></xsl:call-template></xsl:attribute>
              <xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="target" select="$next"/><!--<xsl:with-param name="just.filename" select="1"/>--></xsl:call-template></xsl:attribute>
              <xsl:element name="strong">次:<xsl:text> </xsl:text></xsl:element>
              <xsl:call-template name="href.nav.short">
                <xsl:with-param name="target" select="$next"/>
              </xsl:call-template>
            </a>
          </li>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </ul>
  </xsl:template>
  <!-- BBC This template generates the TOC for the guidelines pages (points to each criterion and technique) -->
  <xsl:template mode="guidelinetoc" match="div2[@role='extsrc']">
    <li>
      <a>
        <xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="target" select="."/></xsl:call-template></xsl:attribute>
        <xsl:apply-templates select="." mode="divnum"/>
        <xsl:choose>
          <xsl:when test="@role='extsrc'">
            <!--xsl:value-of select="$gl-src//div5[@id=current()/@id]/p"/-->
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="head" mode="text"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </li>
  </xsl:template>
  <!-- No need for a horizontal rule divider in the sliced version -->
	<!-- comment out assuming this carried over from Understanding
  <xsl:template match="div2[not(@role='glintent')]">
    <xsl:apply-templates/>
  </xsl:template>
   -->
  <!-- BBC This template generates the TOC for the techniques pages (in-page anchors) -->
  <xsl:template mode="techniquetoc" match="technique[not(@diff = 'del')]">
    <xsl:variable name="gl" select="$gl-src//*[@id = current()/@id]"/>
    <ul id="navbar" >
    	<li>
    		<a href="#{@id}-disclaimer">達成方法に関する重要な情報</a>
    	</li>
        <li>
          <a href="#{@id}-applicability">適用 (対象)</a>
        </li>
                <li>
          <a href="#{@id}-description">解説</a>
        </li>
      <xsl:if test="examples">
        <li>
          <a href="#{@id}-examples">事例</a>
        </li>
      </xsl:if>
            <xsl:if test="resources">
        <li>
          <a href="#{@id}-resources">参考リソース</a>
        </li>
      </xsl:if>
            <xsl:if test="related-techniques">
        <li>
          <a href="#{@id}-related-techs">関連する達成方法</a>
        </li>
      </xsl:if>
            <xsl:if test="tests">
        <li>
          <a href="#{@id}-tests">検証</a>
        </li>
            </xsl:if>
    	<xsl:if test="tech-info">
    		<li><a href="#{@id}-info">Technique Information</a></li>
    	</xsl:if>
    </ul>
  </xsl:template>
  <!-- BBC This template gives us some control over the previous/next links in the navigation -->
  <xsl:template name="href.nav">
    <xsl:param name="target" select="."/>
    <xsl:choose>
      <xsl:when test="$target/ancestor-or-self::front or $target/ancestor-or-self::back"> <xsl:value-of select="$target/head"/></xsl:when>
      <xsl:when test="$target/@id">
        <xsl:value-of select="$target/head"/>
        <xsl:value-of select="$target/@id"/>: <xsl:value-of select="$target/short-name"/>
      </xsl:when>
      <xsl:otherwise>
			</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
    <xsl:template name="href.nav.short">
    <xsl:param name="target" select="."/>
    <xsl:choose>
      <xsl:when test="$target/@id='references'"> <xsl:value-of select="$target/head"/></xsl:when>
      <xsl:when test="$target/@id='intro'"> <xsl:value-of select="$target/head"/></xsl:when>
      <xsl:when test="$target/ancestor-or-self::inform-div1"> <xsl:value-of select="$target/head"/></xsl:when>
      <xsl:when test="$target/../@role='failures'">Failure <xsl:value-of select="$target/@id"/></xsl:when>
      <xsl:when test="$target/@id">
        <xsl:value-of select="$target/head"/>
        達成方法 <xsl:value-of select="$target/@id"/>
      </xsl:when>
      <xsl:otherwise>
			</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--Only differencein the templates below from techniques is that heading level since, with slices, we need to be one heading level higher on all. Warning. Anything changed here should be changed in both locations... -->
  
  <xsl:template match="div1/head">
  <div class="skiptarget"><a id="maincontent">-</a></div>
    <xsl:text> </xsl:text>
    <h1  class="guideline">
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
          <xsl:apply-templates/>
    </h1>
  </xsl:template>
  
  <xsl:template match="div1/div2/head">
    <div class="skiptarget"><a id="maincontent">-</a></div>
    <xsl:text>
</xsl:text>
    <h3>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>
  
  
	<xsl:template match="short-name">
	  <div class="skiptarget"><a id="maincontent">-</a></div>
    <xsl:text> </xsl:text>
		<h1><a name="{../@id}" id="{../@id}"><xsl:text> </xsl:text></a>
			<xsl:call-template name="copy-common-atts"/>
			<xsl:value-of select="../@id"/><xsl:text>: </xsl:text><xsl:apply-templates/>
		</h1>
		<xsl:choose>
			<xsl:when test="$show.diff.markup != 0">
				<div class="diff-add"><span class="difftext">[begin add] </span>
					<xsl:call-template name="techniques.information.reference">
						<xsl:with-param name="id"><xsl:value-of select="../@id"/>-disclaimer</xsl:with-param>
					</xsl:call-template>
					<span class="difftext">[end add]</span></div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="techniques.information.reference">
					<xsl:with-param name="id"><xsl:value-of select="../@id"/>-disclaimer</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>  
  
  
  <xsl:template match="inform-div1/head">
  <div class="skiptarget"><a id="maincontent">-</a></div>
    <xsl:text>
</xsl:text>
    <h1 >
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h1>
  </xsl:template>
  
  <!-- mode: toc Same as techniques single HTML except technologies level isn't linked-->
	<xsl:template mode="toc" match="div1">
		<xsl:param name="local.toc.level" select="$toc.level"/>
		<li>
		<xsl:choose>
    <xsl:when test="@id='intro'">
				<a><xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="target" select="."/></xsl:call-template></xsl:attribute><xsl:apply-templates select="head" mode="text"/></a>
				</xsl:when>
    <xsl:otherwise>
      <!-- @@ check on parenthetical - seems less than ideal -->
      <xsl:apply-templates select="head" mode="text"/> <a><xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="target" select="."/></xsl:call-template></xsl:attribute> (単一ページで全ての<xsl:apply-templates select="head" mode="text"/>)</a>
    </xsl:otherwise>
  </xsl:choose>
						
			<xsl:if test="$local.toc.level &gt; 1">
				<xsl:variable name="children1">
					<xsl:value-of select="count(div2 | technique)"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$children1 = 0"/>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select="div2[not(@diff = 'del')]">
								<li>
									<a>
										<xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="target" select="."/></xsl:call-template></xsl:attribute>
											<xsl:apply-templates select="head" mode="text"/>
										</a>
								</li>
							</xsl:for-each>
							<xsl:for-each select="technique[not(@diff = 'del')]">
								<li>
									<a>
										<xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="target" select="."/></xsl:call-template></xsl:attribute>
											<xsl:value-of select="@id"/>:<xsl:text> </xsl:text>
												<xsl:apply-templates select="head | short-name" mode="text"/>
										</a>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</li>
	</xsl:template>

<xsl:template name="skipnav">
<div id="masthead"><p class="logo"><a href="https://www.w3.org/"><img width="72" height="48" alt="W3C" src="https://www.w3.org/StyleSheets/TR/2016/logos/W3C" /></a></p><p class="collectiontitle"><a href="Overview.html">WCAG 2.0 達成方法集</a></p></div>
<div id="skipnav"><p class="skipnav"><a href="#maincontent">Skip to Content (Press Enter)</a></p>	</div>

<xsl:if test="$show.diff.markup != 0">
              <div id="diffexp">
              <p class="screenreader">This document is a draft, and is designed to show changes from a previous version. It is presently showing <span class="diff-add">added text,</span> <span class="diff-change">changed text,</span> <span class="diff-delete">deleted text,</span><span class="difftext">[start]/[end] markers,</span> <span class="issue">and Issue Numbers</span>.</p>
                <p class="options"><a href="#" onclick="javascript:hideClass('diff-delete'); hideClass('issue'); hideClass('difftext');showClean('diff-change');showClean('diff-add')">Hide<!--Show-->&#160;All&#160;Edits</a> &#160; | &#160; <a href="#" onclick="javascript:toggleClass('diff-delete')">Toggle&#160;Deletions</a>&#160; | &#160; <a href="#"  onclick="javascript:toggleClass('issue')">Toggle&#160;Issue&#160;Numbers</a> &#160; | &#160; <a href="#" onclick="javascript:toggleClass('difftext')">Toggle<!--Hide-->&#160;[start]/[end]&#160;Markers</a> <!--&#160; | &#160; <a href="#">Show&#160;All&#160;Edits</a>-->&#160; | &#160; <a href="#" onclick="javascript:showClass('issue');showClass('diff-delete');showClass('difftext');showChange('diff-change');showAdd('diff-add')">Show&#160;All&#160;Edits</a></p><p class="state">Changes are displayed as follows:</p><ul>     <li> <span class="diff-add"><span class="difftext"> [begin add]</span> new, added text <span class="difftext">[end add] </span></span></li>     <li><span class="diff-change"><span class="difftext"> [begin change]</span> changed text <span class="difftext">[end change], </span></span></li>     <li><span class="diff-delete"><span class="difftext"> [begin delete]</span> deleted text <span class="difftext">[end delete] </span></span></li></ul>        
              </div>
            </xsl:if>
</xsl:template>

<xsl:template name="footer">
<div class="footer">
	<!-- p class="copyright">This Web page is part of <a href="Overview.html">Techniques and Failures for Web Content Accessibility Guidelines 2.0</a><xsl:call-template name="footer-latest-version-ref"/>. The entire document is also available as a <a href="complete.html">single HTML file</a>. See the <a href="http://www.w3.org/WAI/intro/wcag20">The WCAG 2.0 Documents</a> for an explanation of how this document fits in with other Web Content Accessibility Guidelines (WCAG) 2.0 documents. To send public comments, please follow the <a href="http://www.w3.org/WAI/WCAG20/comments/">Instructions for Commenting on WCAG 2.0 Documents</a>.
 </p -->
<p class="copyright">このウェブページは、<a href="Overview.html">WCAG 2.0 達成方法集: WCAG 2.0 の達成方法と失敗例</a><xsl:call-template name="footer-latest-version-ref"/>の一部です。文書全体を<a href="complete.html">単一 HTML ファイルにしたもの</a>もご利用いただけます。この文書と、Web Content Accessibility Guidelines (WCAG) 2.0 に関連する他の文書との関係については、<a href="http://www.w3.org/WAI/intro/wcag20">The WCAG 2.0 Documents</a> をご覧ください。パブリックコメントを送るには、<a href="http://www.w3.org/WAI/WCAG20/comments/">Instructions for Commenting on WCAG 2.0 Documents</a> に従ってください。</p>
	<p class="copyright"><a href="https://www.w3.org/Consortium/Legal/ipr-notice#Copyright">Copyright</a> © <xsl:apply-templates select="//pubdate/year"/><xsl:text> </xsl:text><a href="https://www.w3.org/"><abbr title="World Wide Web Consortium">W3C</abbr></a><sup>®</sup> (<a href="http://www.csail.mit.edu/"><abbr title="Massachusetts Institute of Technology">MIT</abbr></a>, <a href="http://www.ercim.eu/"><abbr title="European Research Consortium for Informatics and Mathematics">ERCIM</abbr></a>, <a href="http://www.keio.ac.jp/">Keio</a>, <a href="http://ev.buaa.edu.cn/">Beihang</a>). W3C <a href="https://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer">liability</a>, <a href="https://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks">trademark</a> and <a href="https://www.w3.org/Consortium/Legal/copyright-documents">document use</a> rules apply.</p>
<p>【注意】 この文書は、W3C ワーキンググループノート <a href="https://www.w3.org/TR/2016/NOTE-WCAG20-TECHS-20161007/">Techniques for WCAG 2.0 の 2016 年 10 月 7 日時点での最新版</a>を<a href="https://waic.jp/committee/wg4/">ウェブアクセシビリティ基盤委員会 (WAIC)</a> が翻訳して公開しているものです。この文書の正式版は、W3C のサイトにある英語版です。正確な内容については、W3C が公開している原文 (英語) をご確認ください。この翻訳文書はあくまで参考情報であり、翻訳上の誤りが含まれていることがあります。翻訳上の誤りを見つけられた場合は、<a href="https://waic.jp/contact/" id="file-issue">翻訳に関するお問い合わせ</a>からご連絡ください。</p>
<p>【重要】 達成方法のタイトルが英語のままになっているものは、日本語訳を行っていないため、原文 (英語) にリンクしています。</p>
</div>
<script src="https://waic.jp/docs/js/translation-contact.js"><xsl:text> </xsl:text></script>
</xsl:template>
  
	<xsl:template name="footer-latest-version-ref">
		<xsl:text> (</xsl:text>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="ancestor::spec//latestloc/loc"/>
				<xsl:apply-templates select="." mode="slice-techniques-filename"/>
			</xsl:attribute>
			<xsl:text>この文書の最新版 (英語)</xsl:text>
		</a>
		<xsl:text> を参照してください) </xsl:text>
	</xsl:template>
	
<xsl:template match="relatedtech">
	<xsl:variable name="id" select="@idref"/>
	<xsl:for-each select="$techs-src//technique[@id=current()/@idref]">
			<li>
				<a href="{$id}.html">
					<xsl:value-of select="$id"></xsl:value-of>: <xsl:apply-templates select="short-name" mode="text"></xsl:apply-templates>
				</a>
			</li>
			</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
