<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:rng="http://relaxng.org/ns/structure/1.0"
		version="1.0">

  <!--* TSD to HTML:  minimal styling for tag set description. 
      *-->

  <!--* Revisions:
      * 2021-11-07 : CMSMcQ : made first version of this stylesheet *-->

  <xsl:output method="xml"
	      indent="yes"/>

  <xsl:variable name="nsxhtml"
		select=" 'http://www.w3.org/1999/xhtml' "/>

  
  <!--****************************************************************
      * 1 Fallback (highlight gaps in stylesheet)
      ****************************************************************
      *-->

  <!-- Default behavior:  spit the element back out in 
       XML notation, colored red.  Calls the developer's
       attention to missing templates. -->
  <xsl:template match="*">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">unknown</xsl:attribute>
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:for-each select="@*">
	<xsl:value-of select="concat(
			      ' ', name(),
			      '=',
			      '&#x22;',
			      string(.),
			      '&#x22;'
			      )"/>
      </xsl:for-each>
      <xsl:text>&gt;</xsl:text>

      <xsl:apply-templates/>

      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>&gt;</xsl:text>      
    </xsl:element>
  </xsl:template>

  <!--****************************************************************
      * 2 Generic TEI P5 (minimal coverage:  elements 
      * actually used so far ...)
      ****************************************************************
      *-->


  <!--* 2.1 Structural elements *-->

  <!--* Document *-->
  <xsl:template match="/">
    <xsl:element name="html" namespace="{$nsxhtml}">
      <xsl:element name="head" namespace="{$nsxhtml}">
	<xsl:element name="title" namespace="{$nsxhtml}">
	  <xsl:text>Tag set description</xsl:text>
	</xsl:element>
	<xsl:element name="style" namespace="{$nsxhtml}">
	  <xsl:attribute name="type">text/css</xsl:attribute>
	  <xsl:text>div.unknown {&#xA;</xsl:text>
	  <xsl:text>    margin: 0 1em;&#xA;</xsl:text>
	  <xsl:text>    color: red;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>span.gi, span.att {&#xA;</xsl:text>
	  <xsl:text>    font-family: monospace;&#xA;</xsl:text>
	  <xsl:text>    color: blue;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>span.label {&#xA;</xsl:text>
	  <xsl:text>    font-weight: bold;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>span.mentioned {&#xA;</xsl:text>
	  <xsl:text>    font-style: italic;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  
	  <xsl:text>div.front {&#xA;</xsl:text>
	  <xsl:text>    text-align: center;&#xA;</xsl:text>
	  <xsl:text>    padding: 2em;;&#xA;</xsl:text>
	  <xsl:text>    border-bottom: 1px solid black;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>div.docAuthor {&#xA;</xsl:text>
	  <xsl:text>    font-size: larger;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  
	  <xsl:text>div.elementSpec {&#xA;</xsl:text>
	  <xsl:text>    margin-top: 2em;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>div.spec-content {&#xA;</xsl:text>
	  <xsl:text>    margin-left: 30%;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>div.spec-content > div {&#xA;</xsl:text>
	  <xsl:text>    margin-bottom: 1em;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>h3.spec-label {&#xA;</xsl:text>
	  <xsl:text>    border-bottom: 1px solid #884444;&#xA;</xsl:text>
	  <xsl:text>    padding-right: 72%;&#xA;</xsl:text>
	  <xsl:text>    padding-top: 0.5em;&#xA;</xsl:text>
	  <xsl:text>    padding-bottom: 0.5em;&#xA;</xsl:text>
	  <xsl:text>    margin-bottom: 1.0em;&#xA;</xsl:text>
	  <xsl:text>    color: maroon;&#xA;</xsl:text>	  
	  <xsl:text>    text-align: right;&#xA;</xsl:text>	  
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>div.exemplum {&#xA;</xsl:text>
	  <xsl:text>    background-color:  #EEDDAA;&#xA;</xsl:text>
	  <xsl:text>    padding: 0.5em 1.0em;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>span.attname {&#xA;</xsl:text>
	  <xsl:text>    font-style: italic;&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  <xsl:text>span.attname:before {&#xA;</xsl:text>
	  <xsl:text>    content: '@';&#xA;</xsl:text>
	  <xsl:text>}&#xA;</xsl:text>
	  
	</xsl:element>
      </xsl:element>
      <xsl:element name="body" namespace="{$nsxhtml}">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:TEI
		       | tei:text
		       | tei:body
		       | tei:div">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@xml:id">
    <xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>
  
  <xsl:template match="tei:teiHeader"/>

  <xsl:template match="tei:div[not(parent::tei:div)]/tei:head">
    <xsl:variable name="depth" select="count(ancestor::tei:div)"/>
    <xsl:choose>
      <xsl:when test="$depth = 1">
	<xsl:element name="h2" namespace="{$nsxhtml}">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$depth = 2">
	<xsl:element name="h3" namespace="{$nsxhtml}">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$depth = 3">
	<xsl:element name="h4" namespace="{$nsxhtml}">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$depth = 4">
	<xsl:element name="h5" namespace="{$nsxhtml}">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--* 2.1b Front matter *-->
  
  <xsl:template match="tei:front
		       | tei:titlePage">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:docTitle">
    <xsl:element name="h1" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:docTitle/tei:titlePart">
    <xsl:element name="span" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:if test="following-sibling::tei:titlePart">
      <xsl:element name="br" namespace="{$nsxhtml}"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:docAuthor | tei:docDate">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>  
  
  <!--* 2.2 Paragraphs and paragraph-level chunks *-->  

  <xsl:template match="tei:p">
    <xsl:element name="{local-name()}" namespace="{$nsxhtml}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:list[not(@type) or @type = 'bullets']">
    <xsl:element name="ul" namespace="{$nsxhtml}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:list[@type = 'ordered']">
    <xsl:element name="ol" namespace="{$nsxhtml}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:item">
    <xsl:element name="li" namespace="{$nsxhtml}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!--* 2.3 Phrase-level elements *-->
    
  <xsl:template match="tei:mentioned">
    <xsl:element name="span" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="tei:gi | tei:att | tei:code">
    <xsl:element name="span" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="tei:soCalled
		       | tei:gloss[
		       not(parent::tei:elementSpec 
		       or parent::tei:attDef)
		       ]">
    <xsl:element name="span" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:text>&#x2018;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#x2019;</xsl:text>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="tei:label[not(parent::tei:list)]">
    <xsl:element name="span" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  

  <!-- hyperlinks -->
  <xsl:template match="tei:ref">
    <xsl:element name="a" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>      
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:ref/@target">
    <xsl:attribute name="href">
      <xsl:value-of select="."/>
    </xsl:attribute> 
  </xsl:template>

  <!--****************************************************************
      * 3 Element specs
      ****************************************************************
      *-->
  
  <xsl:template match="tei:elementSpec">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:element name="h3" namespace="{$nsxhtml}">
	<xsl:attribute name="class">spec-label element</xsl:attribute>
	<xsl:value-of select="@ident"/>
      </xsl:element>      
      <xsl:element name="div" namespace="{$nsxhtml}">
	<xsl:attribute name="class">spec-content</xsl:attribute>
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
    
  </xsl:template>
  
  <xsl:template match="tei:elementSpec/tei:gloss
		       | tei:attributeSpec/tei:gloss">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">block gloss</xsl:attribute>
      <xsl:text>(i.e. </xsl:text>
      <xsl:apply-templates/>
      <xsl:text>)</xsl:text>
    </xsl:element> 
  </xsl:template>
  
  <xsl:template match="tei:desc">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:exemplum">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:eg">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>      
      <xsl:element name="pre" namespace="{$nsxhtml}">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:remarks">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:element name="p" namespace="{$nsxhtml}">
	<xsl:element name="b" namespace="{$nsxhtml}">
	  <xsl:text>Remarks</xsl:text>
	</xsl:element>
      </xsl:element>	
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:content"/>
  
  <xsl:template match="tei:attList">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:element name="p" namespace="{$nsxhtml}">
	<xsl:element name="b" namespace="{$nsxhtml}">
	  <xsl:text>Attributes</xsl:text>
	</xsl:element>
      </xsl:element>	
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:attDef">
    <xsl:element name="div" namespace="{$nsxhtml}">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:element name="p" namespace="{$nsxhtml}">	
	<xsl:element name="span" namespace="{$nsxhtml}">
	  <xsl:attribute name="class">attname</xsl:attribute>
	  <xsl:value-of select="@ident"/>
	</xsl:element>
      </xsl:element>	
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  

</xsl:stylesheet>
