<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns1="http://pilotfish.sqlxml" version="1.0">
  <xsl:template match="/People">
    <ns1:SQLXML>
      <ns1:Update>
        <PEOPLE>
          <PERSON_ID />
          <FIRST_NAME>
            <xsl:text>Updated</xsl:text>
          </FIRST_NAME>
          <MIDDLE_NAME />
          <LAST_NAME />
          <GENDER>
            <xsl:attribute name="key">
              <xsl:text>true</xsl:text>
            </xsl:attribute>
            <xsl:text>Female</xsl:text>
          </GENDER>
          <SSN />
          <BIRTHDATE />
          <OCCUPATION />
          <VEHICLE_MAKE />
          <VEHICLE_MODEL />
          <ADDRESS_LINE_1 />
          <ADDRESS_LINE_2 />
          <CITY />
          <STATE />
          <ZIP />
        </PEOPLE>
      </ns1:Update>
    </ns1:SQLXML>
  </xsl:template>
</xsl:stylesheet>

