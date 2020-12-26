<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/People">
    <xsl:for-each select="Person">
      <Person>
        <Name>
          <First>
            <xsl:value-of select="Name/First" />
          </First>
          <Middle>
            <xsl:value-of select="Name/Middle" />
          </Middle>
          <Last>
            <xsl:value-of select="Name/Last" />
          </Last>
        </Name>
        <Gender>
          <xsl:value-of select="Gender" />
        </Gender>
        <SSN>
          <xsl:value-of select="SSN" />
        </SSN>
        <BirthDate>
          <xsl:value-of select="BirthDate" />
        </BirthDate>
        <Occupation>
          <xsl:value-of select="Occupation" />
        </Occupation>
        <Vehicle>
          <Make>
            <xsl:value-of select="Vehicle/Make" />
          </Make>
          <Model>
            <xsl:value-of select="Vehicle/Model" />
          </Model>
          <Year>
            <xsl:value-of select="Vehicle/Year" />
          </Year>
        </Vehicle>
        <Address>
          <Line1>
            <xsl:value-of select="Address/Line1" />
          </Line1>
          <City>
            <xsl:value-of select="Address/City" />
          </City>
          <State>
            <xsl:value-of select="Address/State" />
          </State>
          <Zip>
            <xsl:value-of select="Address/Zip" />
          </Zip>
        </Address>
      </Person>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

