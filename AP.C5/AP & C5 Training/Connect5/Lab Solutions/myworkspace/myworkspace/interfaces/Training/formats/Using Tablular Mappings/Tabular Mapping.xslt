<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="gender_map_template.xsl" />
  <xsl:template match="/People">
    <People>
      <xsl:for-each select="Person">
        <xsl:choose>
          <xsl:when test="Gender='Female'">
            <Female>
              <FullName>
                <xsl:value-of select="Name/First" />
              </FullName>
              <Gender>
                <xsl:call-template name="TabularMapping_gender_mapping">
                  <xsl:with-param name="value" select="Gender" />
                </xsl:call-template>
              </Gender>
            </Female>
          </xsl:when>
          <xsl:otherwise>
            <Male>
              <FullName>
                <xsl:value-of select="Name/First" />
              </FullName>
              <Gender>
                <xsl:call-template name="TabularMapping_gender_mapping">
                  <xsl:with-param name="value" select="Gender" />
                </xsl:call-template>
              </Gender>
            </Male>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </People>
  </xsl:template>
</xsl:stylesheet>

