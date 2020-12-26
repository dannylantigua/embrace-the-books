<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:converter="xalan://com.pilotfish.eip.transform.ConverterProxy" exclude-result-prefixes="converter" extension-element-prefixes="converter" version="1.0">
  <xsl:template match="/People">
    <converter:register class="com.pilotfish.eip.transform.converters.EchoConverter" name="EchoConverter" params="EchoField">
      <Mode>Echo</Mode>
    </converter:register>
    <People>
      <xsl:for-each select="Person">
        <Person>
          <Name>
            <First>
              <xsl:value-of select="converter:getAttributeString('com.pilotfish.FileName')" />
            </First>
          </Name>
        </Person>
      </xsl:for-each>
    </People>
  </xsl:template>
</xsl:stylesheet>

