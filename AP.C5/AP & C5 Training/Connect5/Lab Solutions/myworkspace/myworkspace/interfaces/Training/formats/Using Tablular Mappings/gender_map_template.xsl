<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template name="TabularMapping_gender_mapping">
    <xsl:param name="value" />
    <xsl:choose>
      <xsl:when test="normalize-space($value)='Female'">
        <xsl:text>F</xsl:text>
      </xsl:when>
      <xsl:when test="normalize-space($value)='Male'">
        <xsl:text>M</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Default value</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

