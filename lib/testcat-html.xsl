<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:gt="http://blackmesatech.com/2020/grammartools"
		xmlns:rtn="http://blackmesatech.com/2020/iXML/recursive-transition-networks"
		xmlns:cat="https://github.com/cmsmcq/ixml-tests"
		>

  <!--* Quick stylesheet for ixml grammars *-->
  <xsl:output method="html"
	      indent="yes"/>

  <xsl:param name="empty-set" select=" '&#x2205;' "/>
  

  <!--* default rule:  show the XML *-->
  <xsl:template match="*" name="unknown">
    <div class="unknown">
      <span class="tag starttag">
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:apply-templates select="@*" mode="unknown"/>
	<xsl:text>&gt;</xsl:text>
      </span>
      <xsl:apply-templates/>      
      <span class="tag endtag">
	<xsl:text>&lt;/</xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:text>&gt;</xsl:text>
      </span>
    </div>
  </xsl:template>
  
  <xsl:template match="@*" mode="unknown">
    <span class="avs">
      <xsl:text> </xsl:text>
      <span class="attname">
	<xsl:value-of select="name()"/>
      </span>
      <span class="attdelims">
	<xsl:text> = "</xsl:text>
      </span>
      <span class="attval">
	<xsl:value-of select="."/>
      </span>
      <span class="attdelims">	
	<xsl:text>"</xsl:text>
      </span>
    </span>
  </xsl:template>

  <!--* document as a whole *-->
  <xsl:template match="/">
    <html>
      <head>
	<title>iXML grammar</title>
	<style type="text/css">
	  div.unknown { color: red; margin-left: 1em; }
	  div.xml { color: navy; margin-left: 1em; }

	  div.block { margin-left: 25%; }
	  div.block > div.block { margin-left: 0; }
	  div.test-set {}
	  div.metadata { width: 100%; background-color: #DDD; }
	  div.app-info { color: brown; }
	  div.ixml-source, div.vxml-source { padding: 0.5em; border: 1px solid navy; white-space: pre;}
	  div.ast { padding: 0.5em; border: 1px solid navy;}
	  div.vxml { padding: 0.5em; padding-left: 0;}
	  div.grammar-test { margin-top: 1em; }
	  h2.test-set { margin-top: 3em; width: 100%; border-bottom: 1px solid black; }
	  h3.test-set { margin-top: 1em; width: 100%; margin-left: 10%; border-bottom: 1px solid black; }
	  span.label { font-weight: normal; }
	  span.test-string { font-family: monospace; font-size: larger; border: 1px solid gray; background-color: #FFFFDD;}
	  span.assertion { font-style: italic;}
	</style>
      </head>
      <body>
	<xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <!--* High-level structure *-->

  <xsl:template match="cat:test-catalog">
    <h1><xsl:value-of select="@name"/></h1>
    <h4>(<xsl:value-of select="@release-date"/>)</h4>
    
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="cat:test-set">
    <h2 class="test-set">
      <xsl:text>Test set: </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="count(descendant::cat:test-case)"/>
      <xsl:text> tests)</xsl:text>
    </h2>
    <xsl:apply-templates/>
  </xsl:template>  
  
  <xsl:template match="cat:test-set/cat:test-set">
    <h3 class="sub test-set">
      <xsl:text>Test set: </xsl:text>
      <xsl:value-of select="@name"/>
    </h3>
    <xsl:apply-templates/>
  </xsl:template>

  
  <xsl:template match="cat:test-set-ref">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block</xsl:text>
      </xsl:attribute>
      <xsl:element name="span">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>Test set: </xsl:text>
      </xsl:element>
      <xsl:element name="a">
	<xsl:attribute name="class">
	  <xsl:text>inline xref</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:value-of select="@href"/>
	</xsl:attribute>
	<xsl:value-of select="@href"/>      
      </xsl:element>
    </xsl:element>
  </xsl:template>  
  
  <xsl:template match="cat:ixml-grammar">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block ixml-source</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="cat:vxml-grammar">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block vxml</xsl:text>
      </xsl:attribute>
      <xsl:element name="b">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>Grammar: </xsl:text>
      </xsl:element>
      <xsl:element name="div">
	<xsl:attribute name="class">
	  <xsl:text>block vxml-source</xsl:text>
	</xsl:attribute>
	<xsl:apply-templates mode="showxml"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="cat:vxml-grammar-ref">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block vxml-ref</xsl:text>
      </xsl:attribute>
      <xsl:element name="span">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>External grammar:  </xsl:text>
      </xsl:element>
      <xsl:element name="a">
	<xsl:attribute name="class">
	  <xsl:text>inline xref</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:value-of select="@href"/>
	</xsl:attribute>
	<xsl:value-of select="@href"/>      
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!--* Individual test cases *-->
  
  <xsl:template match="cat:grammar-test">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block grammar-test</xsl:text>
      </xsl:attribute>
      <xsl:element name="b">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>Grammar test </xsl:text>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="cat:test-case">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block grammar-test</xsl:text>
      </xsl:attribute>
      <xsl:element name="b">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>Test case </xsl:text>
	<xsl:number select="test-case"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="cat:test-string">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block test-string</xsl:text>
      </xsl:attribute>
      <xsl:element name="span">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>Test string: </xsl:text>
      </xsl:element>
      <xsl:element name="span">
	<xsl:attribute name="class">
	  <xsl:text>test-string</xsl:text>
	</xsl:attribute>
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
    <xsl:if test="@gt:hex">
      <xsl:element name="div">
	<xsl:attribute name="class">
	  <xsl:text>block test-string hex</xsl:text>
	</xsl:attribute>
	<xsl:element name="span">
	  <xsl:attribute name="class">
	    <xsl:text>label</xsl:text>
	  </xsl:attribute>
	  <xsl:text>Test string hex: </xsl:text>
	</xsl:element>
	<xsl:element name="span">
	  <xsl:attribute name="class">
	    <xsl:text>hex</xsl:text>
	  </xsl:attribute>
	  <xsl:value-of select="@gt:hex"/>
	</xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
    
  <xsl:template match="cat:test-string-ref">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block test-string</xsl:text>
      </xsl:attribute>
      <xsl:element name="span">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>External test string: </xsl:text>
      </xsl:element>
      <xsl:element name="a">
	<xsl:attribute name="class">
	  <xsl:text>inline xref</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:value-of select="@href"/>
	</xsl:attribute>
	<xsl:value-of select="@href"/>      
      </xsl:element>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="cat:result">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block result</xsl:text>
      </xsl:attribute>
      <xsl:element name="span">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>Result: </xsl:text>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="cat:assert-xml">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block ast</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates mode="showxml"/>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="cat:assert-xml-ref">
    <xsl:element name="a">
      <xsl:attribute name="class">
	<xsl:text>inline xref</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="href">
	<xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:value-of select="@href"/>      
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="cat:assert-not-a-sentence">
    <xsl:element name="span">
      <xsl:attribute name="class">
	<xsl:text>assertion</xsl:text>
      </xsl:attribute>
      <xsl:text>Not a sentence.</xsl:text>
    </xsl:element>
  </xsl:template>

  
  <!--* App info *-->
  <xsl:template match="cat:app-info" mode="no">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block app-info</xsl:text>
      </xsl:attribute>
      <xsl:element name="span">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>App info: </xsl:text>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="cat:app-info">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block app-info</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="cat:raw-parse-tree">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block vxml</xsl:text>
      </xsl:attribute>
      <xsl:element name="b">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>Raw parse: </xsl:text>
      </xsl:element>
      <xsl:element name="div">
	<xsl:attribute name="class">
	  <xsl:text>block raw-parse</xsl:text>
	</xsl:attribute>
	<xsl:apply-templates mode="showxml"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="cat:app-info/cat:raw-parse-tree-ref">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:text>block</xsl:text>
      </xsl:attribute>
      <xsl:element name="span">
	<xsl:attribute name="class">
	  <xsl:text>label</xsl:text>
	</xsl:attribute>
	<xsl:text>Raw parse tree: </xsl:text>
      </xsl:element>
      <xsl:element name="a">
	<xsl:attribute name="class">
	  <xsl:text>inline xref</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:value-of select="@href"/>
	</xsl:attribute>
	<xsl:value-of select="@href"/>      
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!--* Miscellaneous *-->

  <xsl:template match="cat:description">
    <div class="block desc">    
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="cat:p | cat:code">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="cat:test-set/cat:created
		       | cat:test-set/cat:modified">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:value-of select="concat('block metadata ', local-name())"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="cat:created | cat:modified" name="crud">
    <xsl:element name="span">
      <xsl:attribute name="class">
	<xsl:value-of select="concat('inline metadata ', local-name())"/>
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="concat(
			    local-name(),
			    ' by ', 
			    @by, 
			    ' on ', 
			    @on)"/>
      <xsl:if test="self::cat:modified">
	<xsl:value-of select="concat(': ',
			      @change)"/>
      </xsl:if>
      <xsl:text>]</xsl:text>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="cat:test-case/cat:created
		       | cat:test-case/cat:modified"/>


  <!--* default rule:  show the XML *-->
  <xsl:template match="*" mode="showxml">
    <div class="xml">
      <span class="tag starttag">
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:apply-templates select="@*" mode="showxml"/>
	<xsl:text>&gt;</xsl:text>
      </span>
      <xsl:apply-templates mode="showxml"/> 
      <span class="tag endtag">
	<xsl:text>&lt;/</xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:text>&gt;</xsl:text>
      </span>
    </div>
  </xsl:template>
  
  <xsl:template match="@*" mode="showxml">
    <span class="avs">
      <xsl:text> </xsl:text>
      <span class="attname">
	<xsl:value-of select="name()"/>
      </span>
      <span class="attdelims">
	<xsl:text> = "</xsl:text>
      </span>
      <span class="attval">
	<xsl:value-of select="."/>
      </span>
      <span class="attdelims">	
	<xsl:text>"</xsl:text>
      </span>
    </span>
  </xsl:template>  
  
</xsl:stylesheet>
